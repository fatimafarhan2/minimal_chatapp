import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance of FirebaseAuth & Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user
  User? getcurrentuser() {
    return _auth.currentUser;
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user document exists, if not, create it
      var userDoc = await _firestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .get();
      if (!userDoc.exists) {
        _firestore.collection('Users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle specific errors and throw user-friendly messages
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception('An error occurred: ${e.message}');
      }
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      // Create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user info in Firestore
      _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle specific errors and throw user-friendly messages
      if (e.code == 'email-already-in-use') {
        throw Exception('The email is already in use by another account.');
      } else if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else {
        throw Exception('An error occurred: ${e.message}');
      }
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
