import 'dart:developer';

/// Represents a chat in the app.
class BharatIdModel {
  final String bharatId;
  final int type; // 1= primary, 2= secondary

  const BharatIdModel({required this.bharatId, required this.type});

  BharatIdModel copyWith({String? bharatId, int? type}) {
    return BharatIdModel(
      bharatId: bharatId ?? this.bharatId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bharat_id': bharatId,
      'type': type,
    };
  }

  factory BharatIdModel.fromMap(Map<String, dynamic> map) {
    log("fromMap :>: $map");
    return BharatIdModel(
        bharatId: map['bharat_id'] as String, type: map['type'] as int);
  }

  @override
  String toString() {
    return 'Chat(bharat_id: $bharatId, type: $type)';
  }

  @override
  bool operator ==(covariant BharatIdModel other) {
    if (identical(this, other)) return true;

    return other.bharatId == bharatId && other.type == type;
  }

  @override
  int get hashCode {
    return bharatId.hashCode ^ type.hashCode;
  }
}
