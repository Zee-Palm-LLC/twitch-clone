// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentsModel {
  String? commentId;
  DateTime? createdAt;
  String? message;
  String? ownerId;
  String? username;
  CommentsModel({
    this.commentId,
    this.createdAt,
    this.message,
    this.ownerId,
    this.username,
  });

  CommentsModel copyWith({
    String? commentId,
    DateTime? createdAt,
    String? message,
    String? ownerId,
    String? username,
  }) {
    return CommentsModel(
      commentId: commentId ?? this.commentId,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
      ownerId: ownerId ?? this.ownerId,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'message': message,
      'ownerId': ownerId,
      'username': username,
    };
  }

  factory CommentsModel.fromMap(Map<String, dynamic> map) {
    return CommentsModel(
      commentId: map['commentId'] != null ? map['commentId'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      message: map['message'] != null ? map['message'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentsModel.fromJson(String source) =>
      CommentsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentsModel(commentId: $commentId, createdAt: $createdAt, message: $message, ownerId: $ownerId, username: $username)';
  }
}
