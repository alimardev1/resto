import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/auth_providers.dart';
import '../../utils/snackbar.dart';
import '../../utils/constants.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = ref.watch(authControllerProvider);
    final isPasswordVisible = useState(false);

    // 1. Create controllers for scrolling and focus detection using hooks
    final scrollController = useScrollController();
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    // 2. Use the useEffect hook to add listeners. This runs once.
    useEffect(() {
      // The function that will be triggered on focus change
      void handleFocusChange() {
        // We wait a short moment for the keyboard to begin animating
        Future.delayed(const Duration(milliseconds: 300), () {
          if (scrollController.hasClients) {
            // Animate to the bottom of the scroll view
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }

      // Add the listener to both focus nodes
      emailFocusNode.addListener(handleFocusChange);
      passwordFocusNode.addListener(handleFocusChange);

      // The cleanup function for when the widget is disposed
      return () {
        emailFocusNode.removeListener(handleFocusChange);
        passwordFocusNode.removeListener(handleFocusChange);
      };
    }, [emailFocusNode, passwordFocusNode]); // Dependencies for the effect

    void handleLogin() async {
      FocusScope.of(context).unfocus();
      if (formKey.currentState?.validate() ?? false) {
        try {
          await ref
              .read(authControllerProvider.notifier)
              .signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
        } catch (e) {
          if (!context.mounted) return;
          showSnackBar(context, e.toString());
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          // 3. Attach the scroll controller to the ListView
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/images/logo.png', height: 80),
            const SizedBox(height: 16),
            Text(
              'Welcome Back',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to your POS dashboard',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
            ),
            const SizedBox(height: 48),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    // 4. Attach the focus node
                    focusNode: emailFocusNode,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: UIStrings.emailLabel,
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    // 5. Attach the focus node
                    focusNode: passwordFocusNode,
                    controller: passwordController,
                    obscureText: !isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: UIStrings.passwordLabel,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          isPasswordVisible.value = !isPasswordVisible.value;
                        },
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: handleLogin,
                child: const Text(UIStrings.loginButton),
              ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () => context.push(AppRoutes.register),
                  child: const Text(UIStrings.dontHaveAccount),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.forgotPassword),
                  child: const Text(UIStrings.forgotPasswordPrompt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
