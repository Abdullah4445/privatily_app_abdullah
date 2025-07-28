import 'package:cloud_firestore/cloud_firestore.dart';

class Students {
  String name;
  String id;
  int? createdAt; // Store as int (microsecondsSinceEpoch)

  // Additional Fields
  String? email;
  String? rollNo;
  String? className;
  String? section;
  String? contact;
  String? fee;
  String? attendance;
  String? address;
  String? guardianName;

  // Parent Info
  String? parentName;
  String? parentContact;
  String? parentOccupation;
  String? parentAddress;
  String? relationship;

  // Extra Academic Info
  List<String>? courseList;

  // Fee History
  List<Map<String, dynamic>>? feeHistory;

  Students({
    required this.name,
    required this.id,
    this.createdAt,
    this.email,
    this.rollNo,
    this.className,
    this.section,
    this.contact,
    this.fee,
    this.attendance,
    this.address,
    this.guardianName,
    this.parentName,
    this.parentContact,
    this.parentOccupation,
    this.parentAddress,
    this.relationship,
    this.courseList,
    this.feeHistory,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'createdAt': createdAt, // Store as int (microsecondsSinceEpoch)
      'email': email,
      'rollNo': rollNo,
      'className': className,
      'section': section,
      'contact': contact,
      'fee': fee,
      'attendance': attendance,
      'address': address,
      'guardianName': guardianName,
      'parentName': parentName,
      'parentContact': parentContact,
      'parentOccupation': parentOccupation,
      'parentAddress': parentAddress,
      'relationship': relationship,
      'courseList': courseList,
      'feeHistory': feeHistory,
    };
  }

  factory Students.fromJson(Map<String, dynamic> json) {
    int? createdAtTimestamp;

    // Check if "createdAt" is a Timestamp (Firestore)
    if (json['createdAt'] is Timestamp) {
      createdAtTimestamp = (json['createdAt'] as Timestamp).microsecondsSinceEpoch; // Convert Timestamp to int
    } else if (json['createdAt'] is int) {
      createdAtTimestamp = json['createdAt']; // If it's already int (microseconds)
    } else {
      // If createdAt is missing or not a valid type, use current time as a fallback
      createdAtTimestamp = DateTime.now().microsecondsSinceEpoch;
    }

    return Students(
      name: json['name'] as String? ?? 'Unknown', // Default to 'Unknown' if missing
      id: json['id'] as String? ?? '', // Default to empty string if missing
      createdAt: createdAtTimestamp,
      email: json['email'] as String? ?? '',
      rollNo: json['rollNo'] as String? ?? '',
      className: json['className'] as String? ?? '',
      section: json['section'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      fee: json['fee'] as String? ?? '',
      attendance: json['attendance'] as String? ?? '',
      address: json['address'] as String? ?? '',
      guardianName: json['guardianName'] as String? ?? '',
      parentName: json['parentName'] as String? ?? '',
      parentContact: json['parentContact'] as String? ?? '',
      parentOccupation: json['parentOccupation'] as String? ?? '',
      parentAddress: json['parentAddress'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      courseList: (json['courseList'] as List?)?.map((e) => e as String).toList(),
      feeHistory: (json['feeHistory'] as List?)?.map((item) => Map<String, dynamic>.from(item as Map)).toList(),
    );
  }
}