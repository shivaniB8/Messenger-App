import 'dart:developer';

/// Represents a chat in the app.
class BharatIdModel {
  final String id;
  final String bharatId;
  final String qr;
  final int type; // 1= primary, 2= secondary
  final int status; // 0= In active, 1= active

  const BharatIdModel(
      {required this.id,
      required this.bharatId,
      required this.qr,
      required this.type,
      required this.status});

  BharatIdModel copyWith(
      {String? bharatId, String? qr, int? type, int? status, String? id}) {
    return BharatIdModel(
      id: id ?? this.id,
      qr: qr ?? this.qr,
      status: status ?? this.status,
      bharatId: bharatId ?? this.bharatId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'qr': qr,
      'bharat_id': bharatId,
      'type': type,
      'status': status,
    };
  }

  factory BharatIdModel.fromMap(Map<String, dynamic> map) {
    log("fromMap :>: $map");
    return BharatIdModel(
      id: map['id'] as String,
      qr: map['qr'] as String,
      bharatId: map['bharat_id'] as String,
      type: map['type'] as int,
      status: map['status'] as int,
    );
  }

  @override
  String toString() {
    return 'BharatIdModel(id: $id,qr: $qr,bharat_id: $bharatId, type: $type,status: $status)';
  }

  @override
  bool operator ==(covariant BharatIdModel other) {
    if (identical(this, other)) return true;

    return other.bharatId == bharatId &&
        other.id == id &&
        other.qr == qr &&
        other.type == type &&
        other.status == status;
  }

  @override
  int get hashCode {
    return bharatId.hashCode ^
        type.hashCode ^
        status.hashCode ^
        id.hashCode ^
        qr.hashCode;
  }
}
