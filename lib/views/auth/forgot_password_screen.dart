import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/auth_providers.dart';
import '../../utils/snackbar.dart';
import '../../utils/constants.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final isLoading = ref.watch(authControllerProvider);

    void handleResetPassword() async {
      try {
        await ref
            .read(authControllerProvider.notifier)
            .sendPasswordResetEmail(email: emailController.text.trim());

        if (!context.mounted) return;
        showSnackBar(
          context,
          "Password reset link sent to your email. Please check.",
        );
        context.pop();
      } catch (e) {
        if (!context.mounted) return;
        showSnackBar(context, e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(UIStrings.forgotPasswordTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text(
                          'Receive a reset link',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Enter your account email below to receive a password reset link.',
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: UIStrings.emailLabel,
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        if (isLoading)
                          const CircularProgressIndicator()
                        else
                          ElevatedButton(
                            onPressed: handleResetPassword,
                            child: const Text(UIStrings.resetButton),
                          ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
