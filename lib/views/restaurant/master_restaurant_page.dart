import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_number/phone_number.dart';
import '../../providers/restaurant_provider.dart';
import '../../utils/snackbar.dart';

class MasterRestaurantPage extends HookConsumerWidget {
  const MasterRestaurantPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final addressController = useTextEditingController();
    final phoneController = useTextEditingController();
    final localImageFile = useState<File?>(null);

    // 1. State to hold the async phone validation error message
    final phoneValidationError = useState<String?>(null);

    final restaurantAsync = ref.watch(restaurantStreamProvider);
    final isLoading = ref.watch(restaurantControllerProvider);
    final imagePicker = useMemoized(() => ImagePicker());
    final phoneUtil = useMemoized(() => PhoneNumberUtil());

    useEffect(() {
      final restaurant = restaurantAsync.asData?.value;
      if (restaurant != null) {
        nameController.text = restaurant.name;
        addressController.text = restaurant.address;
        phoneController.text = restaurant.phone;
      }
      return null;
    }, [restaurantAsync]);

    // 2. useEffect to clear the phone error when the user starts typing again
    useEffect(() {
      void listener() {
        if (phoneValidationError.value != null) {
          phoneValidationError.value = null;
        }
      }

      phoneController.addListener(listener);
      return () => phoneController.removeListener(listener);
    }, [phoneController]);

    void pickImage() async {
      final XFile? imageXFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (imageXFile == null) return;
      localImageFile.value = File(imageXFile.path);
    }

    void handleSaveChanges() async {
      FocusScope.of(context).unfocus();
      if (formKey.currentState?.validate() ?? false) {
        final String phoneNumberString = phoneController.text.trim();
        bool isValidPhoneNumber = false;
        try {
          isValidPhoneNumber = await phoneUtil.validate(phoneNumberString);
        } catch (e) {
          isValidPhoneNumber = false;
        }

        // 3. Update the error state instead of showing a SnackBar
        if (!isValidPhoneNumber) {
          phoneValidationError.value =
              'Please enter a valid international phone number.';
          return;
        }

        final existingLogoUrl = restaurantAsync.asData?.value?.logoUrl;

        ref
            .read(restaurantControllerProvider.notifier)
            .saveDetails(
              name: nameController.text,
              address: addressController.text,
              phone: phoneNumberString,
              newLogoFile: localImageFile.value,
              existingLogoUrl: existingLogoUrl,
            )
            .then((_) {
              showSnackBar(context, 'Changes saved successfully!');
              localImageFile.value = null;
            })
            .catchError((e) => showSnackBar(context, 'Error: $e'));
      }
    }

    ImageProvider? getBackgroundImage() {
      if (localImageFile.value != null) {
        return FileImage(localImageFile.value!);
      }
      final networkUrl = restaurantAsync.asData?.value?.logoUrl;
      if (networkUrl != null) {
        return NetworkImage(networkUrl);
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Restaurant')),
      body: restaurantAsync.when(
        data:
            (restaurant) => ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        backgroundImage: getBackgroundImage(),
                        child:
                            getBackgroundImage() == null
                                ? const Icon(Icons.storefront, size: 50)
                                : null,
                      ),
                      if (isLoading)
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black54,
                          child: CircularProgressIndicator(),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.black,
                            ),
                            onPressed: isLoading ? null : pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Restaurant Name',
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Please enter a name' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Please enter an address'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '+1 201-555-0123',
                          // 4. Use the errorText property to display the validation message
                          errorText: phoneValidationError.value,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null; // The detailed validation happens on save
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isLoading ? null : handleSaveChanges,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
