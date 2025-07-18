import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';

class RestaurantService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'restaurants';

  // Get a real-time stream of the user's restaurant data
  Stream<RestaurantModel?> getRestaurantStream(String userId) {
    return _db.collection(_collectionPath).doc(userId).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists) {
        return RestaurantModel.fromFirestore(snapshot);
      }
      return null; // Return null if no restaurant data exists yet
    });
  }

  // Save (create or update) restaurant details
  Future<void> saveRestaurantDetails(RestaurantModel restaurant) async {
    await _db
        .collection(_collectionPath)
        .doc(restaurant.id)
        .set(restaurant.toJson(), SetOptions(merge: true));
  }

  Future<void> updateLogoUrl(String userId, String logoUrl) async {
    await _db.collection(_collectionPath).doc(userId).update({
      'logoUrl': logoUrl,
    });
  }
}
