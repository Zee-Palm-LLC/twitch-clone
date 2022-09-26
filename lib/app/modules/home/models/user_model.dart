import 'dart:convert';

class UserModel {
  final String? uid;
  final String? username;
  final String? email;

  UserModel({
    this.uid,
    this.username,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
