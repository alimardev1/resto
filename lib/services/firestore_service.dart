import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/constants.dart'; // Import the constants file

class FirestoreService {
  final FirebaseFirestore _db;
  FirestoreService(this._db);

  Future<void> addUser(AppUser user) async {
    // Use the constant for the collection name
    await _db
        .collection(DBConstants.usersCollection)
        .doc(user.uid)
        .set(user.toJson());
  }
}
