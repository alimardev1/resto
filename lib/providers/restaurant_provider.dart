import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../controllers/restaurant_controller.dart';
import '../models/restaurant_model.dart';
import '../services/restaurant_service.dart';
import 'auth_providers.dart';

// Provides the RestaurantService instance
final restaurantServiceProvider = Provider<RestaurantService>((ref) {
  return RestaurantService();
});

// Provides the stream of restaurant data for the current user
final restaurantStreamProvider = StreamProvider.autoDispose<RestaurantModel?>((
  ref,
) {
  final user = ref.watch(authStateChangeProvider).asData?.value;
  if (user != null) {
    return ref.watch(restaurantServiceProvider).getRestaurantStream(user.uid);
  }
  return Stream.value(null);
});

// Provides the RestaurantController instance
final restaurantControllerProvider =
    StateNotifierProvider.autoDispose<RestaurantController, bool>((ref) {
      return RestaurantController(ref);
    });
