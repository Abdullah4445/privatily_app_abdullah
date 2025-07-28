class CourseModel {
  final String id;
  final String name;
  final double duration;
  final int fee;
  final List<String> contents;
  final List<String> notes;
  final List<String> audioUrls;
  final List<String> videoUrls;
  final String? thumbnailUrl;
  final String? description;
  final String? instructor;
  final List<String>? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isPublished;
  final List<String>? enrolledUsers;
  final double? rating;
  final int? totalRatings;
  final String? category;
  final List<String>? language;
  final String? level;
  final List<String>? prerequisites;
  final Map<String, double>? progressMap; // userId -> progress %

  CourseModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.fee,
    required this.contents,
    required this.notes,
    required this.audioUrls,
    required this.videoUrls,
    this.thumbnailUrl,
    this.description,
    this.instructor,
    this.tags,
    this.createdAt,
    this.updatedAt,
    this.isPublished = false,
    this.enrolledUsers,
    this.rating,
    this.totalRatings,
    this.category,
    this.language,
    this.level,
    this.prerequisites,
    this.progressMap,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      duration: (json['duration'] is int)
          ? (json['duration'] as int).toDouble()
          : (json['duration'] ?? 0.0),
      fee: json['fee'] ?? 0,
      contents: List<String>.from(json['contents'] ?? []),
      notes: List<String>.from(json['notes'] ?? []),
      audioUrls: List<String>.from(json['audioUrls'] ?? []),
      videoUrls: List<String>.from(json['videoUrls'] ?? []),
      thumbnailUrl: json['thumbnailUrl'],
      description: json['description'],
      instructor: json['instructor'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      isPublished: json['isPublished'] ?? false,
      enrolledUsers: json['enrolledUsers'] != null
          ? List<String>.from(json['enrolledUsers'])
          : null,
      rating: (json['rating'] != null)
          ? (json['rating'] as num).toDouble()
          : null,
      totalRatings: json['totalRatings'],
      category: json['category'],
      language: List<String>.from(json['language']??[]),
      level: json['level'],
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'])
          : null,
      progressMap: json['progressMap'] != null
          ? Map<String, double>.from((json['progressMap'] as Map).map(
              (key, value) => MapEntry(key, (value as num).toDouble())))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'fee': fee,
      'contents': contents,
      'notes': notes,
      'audioUrls': audioUrls,
      'videoUrls': videoUrls,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'instructor': instructor,
      'tags': tags,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isPublished': isPublished,
      'enrolledUsers': enrolledUsers,
      'rating': rating,
      'totalRatings': totalRatings,
      'category': category,
      'language': language,
      'level': level,
      'prerequisites': prerequisites,
      'progressMap': progressMap,
    };
  }
}