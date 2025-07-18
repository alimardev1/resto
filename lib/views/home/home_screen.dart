import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resto/utils/constants.dart';
import 'package:resto/views/widgets/notification_bell.dart';
import '../../providers/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangeProvider);
    final userEmail = authState.value?.email ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Home'), // Or use UIStrings.appTitle
        actions: [
          // Add the NotificationBell here
          const NotificationBell(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $userEmail! 👋'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.manageRestaurant),
              child: const Text('Manage Restaurant Details'),
            ),
          ],
        ),
      ),
    );
  }
}
