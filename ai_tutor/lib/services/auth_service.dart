import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get authentication state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a new user document in Firestore
      await _createUserInFirestore(
        uid: result.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Create user in Firestore
  Future<void> _createUserInFirestore({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    DateTime now = DateTime.now();
    UserModel user = UserModel(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      createdAt: now,
      lastLogin: now,
    );

    await _firestore.collection('users').doc(uid).set(user.toMap());

    // Save basic user data to shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_firstName', firstName);
    prefs.setString('user_lastName', lastName);
    prefs.setString('user_email', email);
    prefs.setString('user_uid', uid);
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user's last login timestamp
      await _updateUserLastLogin(result.user!.uid);

      // Fetch and save user data to shared preferences
      await _saveUserDataToPrefs(result.user!.uid);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Update user's last login timestamp
  Future<void> _updateUserLastLogin(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'lastLogin': DateTime.now(),
    });
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserDataToPrefs(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();

        prefs.setString('user_firstName', data['firstName'] ?? '');
        prefs.setString('user_lastName', data['lastName'] ?? '');
        prefs.setString('user_email', data['email'] ?? '');
        prefs.setString('user_uid', uid);

        if (data['profilePicture'] != null) {
          prefs.setString('user_profilePicture', data['profilePicture']);
        }
      }
    } catch (e) {
      print('Error saving user data to preferences: $e');
    }
  }

  // Get user from Firestore
  Future<UserModel?> getUserData() async {
    if (_auth.currentUser == null) return null;

    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? profilePicture,
    String? educationalStatus,
  }) async {
    if (_auth.currentUser == null) return;

    Map<String, dynamic> updateData = {};

    if (firstName != null) updateData['firstName'] = firstName;
    if (lastName != null) updateData['lastName'] = lastName;
    if (profilePicture != null) updateData['profilePicture'] = profilePicture;
    if (educationalStatus != null)
      updateData['educationalStatus'] = educationalStatus;

    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update(updateData);

    // Update local cache
    final prefs = await SharedPreferences.getInstance();
    if (firstName != null) prefs.setString('user_firstName', firstName);
    if (lastName != null) prefs.setString('user_lastName', lastName);
    if (profilePicture != null)
      prefs.setString('user_profilePicture', profilePicture);
  }

  // Sign out
  Future<void> signOut() async {
    // Clear user data from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_firstName');
    await prefs.remove('user_lastName');
    await prefs.remove('user_email');
    await prefs.remove('user_uid');
    await prefs.remove('user_profilePicture');

    // Sign out from Firebase
    return await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Get user display name from SharedPreferences (for quick access)
  Future<String> getUserDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    String firstName = prefs.getString('user_firstName') ?? '';
    String lastName = prefs.getString('user_lastName') ?? '';

    if (firstName.isEmpty && lastName.isEmpty) {
      // If we don't have the name cached, try to get it from Firestore
      final userData = await getUserData();
      if (userData != null) {
        firstName = userData.firstName;
        lastName = userData.lastName;

        // Update the cache
        prefs.setString('user_firstName', firstName);
        prefs.setString('user_lastName', lastName);
      }
    }

    return '$firstName $lastName'.trim();
  }
}
