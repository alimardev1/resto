import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/auth_providers.dart';
import '../providers/notification_provider.dart';

class NotificationController {
  final Ref _ref;

  NotificationController(this._ref);

  Future<void> markNotificationAsRead(String notificationId) async {
    final user = _ref.read(authStateChangeProvider).asData?.value;
    if (user == null) return; // Not logged in, do nothing

    try {
      await _ref
          .read(notificationServiceProvider)
          .markAsRead(user.uid, notificationId);
    } catch (e) {
      // Handle or log error if needed
      print("Error marking notification as read: $e");
    }
  }
}
