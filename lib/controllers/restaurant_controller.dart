import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/restaurant_model.dart';
import '../providers/auth_providers.dart';
import '../providers/restaurant_provider.dart';
import '../providers/storage_provider.dart';

class RestaurantController extends StateNotifier<bool> {
  final Ref _ref;
  RestaurantController(this._ref) : super(false);

  // The saveDetails method is now updated to handle an optional image file.
  Future<bool> saveDetails({
    required String name,
    required String address,
    required String phone,
    File? newLogoFile, // The new logo file is now an optional parameter
    String? existingLogoUrl, // We need the old URL in case there's no new file
  }) async {
    state = true;
    final user = _ref.read(authStateChangeProvider).asData?.value;
    if (user == null) {
      state = false;
      throw Exception('User not authenticated');
    }

    String? finalLogoUrl = existingLogoUrl;

    try {
      // 1. If a new logo file exists, upload it.
      if (newLogoFile != null) {
        final storagePath = 'logos/${user.uid}/logo.jpg';
        finalLogoUrl = await _ref
            .read(storageServiceProvider)
            .uploadImage(storagePath, newLogoFile);
      }

      // 2. Create the RestaurantModel with all data.
      final restaurant = RestaurantModel(
        id: user.uid,
        name: name,
        address: address,
        phone: phone,
        logoUrl: finalLogoUrl, // Use the new URL or the existing one
      );

      // 3. Save everything to Firestore.
      await _ref
          .read(restaurantServiceProvider)
          .saveRestaurantDetails(restaurant);
      state = false;
      return true;
    } catch (e) {
      state = false;
      rethrow;
    }
  }
}
