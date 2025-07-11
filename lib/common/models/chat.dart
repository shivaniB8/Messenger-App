import 'dart:developer';

/// Represents a chat in the app.
class ChatModel {
  final String name;
  final String profileImage;
  final String receiverId;
  final DateTime lastMessageTime;
  final String lastMessage;
  final String phoneNumber;

  const ChatModel({
    required this.name,
    required this.phoneNumber,
    required this.profileImage,
    required this.receiverId,
    required this.lastMessageTime,
    required this.lastMessage,
  });

  ChatModel copyWith({
    String? name,
    String? phoneNumber,
    String? profileImage,
    String? receiverId,
    DateTime? lastMessageTime,
    String? lastMessage,
  }) {
    return ChatModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      receiverId: receiverId ?? this.receiverId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'receiverId': receiverId,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    log("fromMap :>: $map");
    return ChatModel(
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as String,
      profileImage: map['profileImage'] as String,
      receiverId: map['receiverId'] as String,
      lastMessageTime:
          DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }

  @override
  String toString() {
    return 'Chat(name: $name, phoneNumber: $phoneNumber,profileImage: $profileImage, receiverId: $receiverId, lastMessageTime: $lastMessageTime, lastMessage: $lastMessage)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profileImage == profileImage &&
        other.phoneNumber == phoneNumber &&
        other.receiverId == receiverId &&
        other.lastMessageTime == lastMessageTime &&
        other.lastMessage == lastMessage;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profileImage.hashCode ^
        phoneNumber.hashCode ^
        receiverId.hashCode ^
        lastMessageTime.hashCode ^
        lastMessage.hashCode;
  }
}
