import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthController extends StateNotifier<bool> {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  // final Ref _ref; <-- This line is removed

  // The 'ref' parameter is removed from the constructor
  AuthController(this._authService, this._firestoreService)
    : super(false); // Initial state: not loading

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName, // Added parameter
  }) async {
    state = true;
    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create the AppUser with the new displayName
        final newUser = AppUser(
          uid: userCredential.user!.uid,
          email: email,
          displayName: displayName, // Pass it here
        );
        await _firestoreService.addUser(newUser);
        state = false;
        return true;
      }
      state = false;
      return false;
    } catch (e) {
      state = false;
      rethrow;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = true;
    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = false;
      return true;
    } catch (e) {
      state = false;
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    state = true;
    try {
      await _authService.sendPasswordResetEmail(email: email);
      state = false;
    } catch (e) {
      state = false;
      rethrow;
    }
  }

  Future<void> signOut() async {
    // No need for loading state here, it's usually instant
    await _authService.signOut();
  }
}
