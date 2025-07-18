import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

// Provides an instance of FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

// Provides an instance of FirebaseFirestore
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

// Provides an instance of our AuthService, which depends on FirebaseAuth
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.read(firebaseAuthProvider)),
);

// Provides an instance of our FirestoreService
final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(ref.read(firestoreProvider)),
);

// The famous authStateChanges stream provider.
// This is the single source of truth for the user's authentication state.
// The UI will listen to this to know if a user is logged in or not.
// Riverpod automatically handles closing the stream when it's no longer needed.
final authStateChangeProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChanges,
);

// Provides the AuthController. We use StateNotifierProvider because
// the controller will manage some state (like isLoading).
final authControllerProvider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  return AuthController(
    ref.read(authServiceProvider),
    ref.read(firestoreServiceProvider),
  );
});
