import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final String? educationalStatus;
  final DateTime createdAt;
  final DateTime lastLogin;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    this.educationalStatus,
    required this.createdAt,
    required this.lastLogin,
  });

  // Create a UserModel from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      profilePicture: map['profilePicture'],
      educationalStatus: map['educationalStatus'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLogin: (map['lastLogin'] as Timestamp).toDate(),
    );
  }

  // Convert the UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
      'educationalStatus': educationalStatus,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
    };
  }

  // Method to update a user's data without changing their UID or email
  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? profilePicture,
    String? educationalStatus,
    DateTime? lastLogin,
  }) {
    return UserModel(
      uid: this.uid,
      email: this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      educationalStatus: educationalStatus ?? this.educationalStatus,
      createdAt: this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
