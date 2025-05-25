

// --- Main Project Model ---
class Project {
  final int? createdAt;
  final List<DemoAdminPanelLink>? demoAdminPanelLinks;
  final List<String>? mobileShotUrls;
  final List<DemoApkLink>? demoApkLinks;
  final String? demoDetails;
  final String? demoVideoUrl;
  final bool? isCustomizationAvailable;
  final bool? isProjectEnabled;
  final String? name;
  final double? price;
  final String? projectDesc;
  final String? projectId;
  final String? projectLink;
  final List<String>? reviews;
  final int? soldCount;
  final String? subtitle;
  final List<String>? teamMemberIds;
  final String? thumbnailUrl;
  final String? title;
  final dynamic updatedAt;

  Project({
    this.createdAt,
    this.demoAdminPanelLinks,
    this.mobileShotUrls,
    this.demoApkLinks,
    this.demoDetails,
    this.demoVideoUrl,
    this.isCustomizationAvailable,
    this.isProjectEnabled,
    this.name,
    this.price,
    this.projectDesc,
    this.projectId,
    this.projectLink,
    this.reviews,
    this.soldCount,
    this.subtitle,
    this.teamMemberIds,
    this.thumbnailUrl,
    this.title,
    this.updatedAt,
  });

  /// ✅ Add this method to support partial updates (like translated title/description)
  Project copyWith({
    int? createdAt,
    List<DemoAdminPanelLink>? demoAdminPanelLinks,
    List<String>? mobileShotUrls,
    List<DemoApkLink>? demoApkLinks,
    String? demoDetails,
    String? demoVideoUrl,
    bool? isCustomizationAvailable,
    bool? isProjectEnabled,
    String? name,
    double? price,
    String? projectDesc,
    String? projectId,
    String? projectLink,
    List<String>? reviews,
    int? soldCount,
    String? subtitle,
    List<String>? teamMemberIds,
    String? thumbnailUrl,
    String? title,
    dynamic updatedAt,
  }) {
    return Project(
      createdAt: createdAt ?? this.createdAt,
      demoAdminPanelLinks: demoAdminPanelLinks ?? this.demoAdminPanelLinks,
      mobileShotUrls: mobileShotUrls ?? this.mobileShotUrls,
      demoApkLinks: demoApkLinks ?? this.demoApkLinks,
      demoDetails: demoDetails ?? this.demoDetails,
      demoVideoUrl: demoVideoUrl ?? this.demoVideoUrl,
      isCustomizationAvailable: isCustomizationAvailable ?? this.isCustomizationAvailable,
      isProjectEnabled: isProjectEnabled ?? this.isProjectEnabled,
      name: name ?? this.name,
      price: price ?? this.price,
      projectDesc: projectDesc ?? this.projectDesc,
      projectId: projectId ?? this.projectId,
      projectLink: projectLink ?? this.projectLink,
      reviews: reviews ?? this.reviews,
      soldCount: soldCount ?? this.soldCount,
      subtitle: subtitle ?? this.subtitle,
      teamMemberIds: teamMemberIds ?? this.teamMemberIds,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // --- Your existing factory and toJson methods stay the same ---

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    createdAt: json['createdAt'] as int?,
    demoAdminPanelLinks: (json['demoAdminPanelLinks'] as List<dynamic>?)
        ?.map((x) => DemoAdminPanelLink.fromJson(x as Map<String, dynamic>))
        .toList(),
    mobileShotUrls: (json['shotUrls'] as List<dynamic>?)
        ?.map((x) => x as String)
        .toList(),
    demoApkLinks: (json['demoApkLinks'] as List<dynamic>?)
        ?.map((x) => DemoApkLink.fromJson(x as Map<String, dynamic>))
        .toList(),
    demoDetails: json['demoDetails'] as String?,
    demoVideoUrl: json['demoVideoUrl'] as String?,
    isCustomizationAvailable: json['isCustomizationAvailable'] as bool?,
    isProjectEnabled: json['isProjectEnabled'] as bool?,
    name: json['name'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    projectDesc: json['projectDesc'] as String?,
    projectId: json['projectId'] as String?,
    projectLink: json['projectLink'] as String?,
    reviews: (json['reviews'] as List<dynamic>?)
        ?.map((x) => x as String)
        .toList(),
    soldCount: json['soldCount'] as int?,
    subtitle: json['subtitle'] as String?,
    teamMemberIds: (json['teamMemberIds'] as List<dynamic>?)
        ?.map((x) => x as String)
        .toList(),
    thumbnailUrl: json['thumbnailUrl'] as String?,
    title: json['title'] as String?,
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'demoAdminPanelLinks': demoAdminPanelLinks?.map((x) => x.toJson()).toList(),
    'shotUrls': mobileShotUrls,
    'demoApkLinks': demoApkLinks?.map((x) => x.toJson()).toList(),
    'demoDetails': demoDetails,
    'demoVideoUrl': demoVideoUrl,
    'isCustomizationAvailable': isCustomizationAvailable,
    'isProjectEnabled': isProjectEnabled,
    'name': name,
    'price': price,
    'projectDesc': projectDesc,
    'projectId': projectId,
    'projectLink': projectLink,
    'reviews': reviews,
    'soldCount': soldCount,
    'subtitle': subtitle,
    'teamMemberIds': teamMemberIds,
    'thumbnailUrl': thumbnailUrl,
    'title': title,
    'updatedAt': updatedAt,
  };

  // --- Your screenshot helpers stay unchanged ---
  List<String> get adminPanelScreenshots {
    final List<String> shots = [];
    if (demoAdminPanelLinks != null) {
      for (var link in demoAdminPanelLinks!) {
        if (link.shotUrls != null) {
          shots.addAll(link.shotUrls!);
        }
      }
    }
    return shots;
  }

  List<String> get mobileAppScreenshots => mobileShotUrls ?? [];

  List<String> get apkDemoScreenshots {
    final List<String> shots = [];
    if (demoApkLinks != null) {
      for (var link in demoApkLinks!) {
        if (link.shotUrls != null) {
          shots.addAll(link.shotUrls!);
        }
      }
    }
    return shots;
  }
}


// --- Model for items in the 'demoAdminPanelLinks' array ---
class DemoAdminPanelLink {
  final String? link;
  final String? name;
  final List<String>? shotUrls; // Nested screenshots for admin panel

  DemoAdminPanelLink({
    this.link,
    this.name,
    this.shotUrls, // Add to constructor
  });

  factory DemoAdminPanelLink.fromJson(Map<String, dynamic> json) =>
      DemoAdminPanelLink(
        link: json['link'] as String?,
        name: json['name'] as String?,
        shotUrls: (json['shotUrls'] as List<dynamic>?) // Parse nested list
            ?.map((x) => x as String)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'link': link,
    'name': name,
    'shotUrls': shotUrls, // Add to JSON output
  };
}

// --- Model for items in the 'demoApkLinks' array ---
class DemoApkLink {
  final String? link;
  final String? name;
  final List<String>? shotUrls; // Nested screenshots for APK demo

  DemoApkLink({
    this.link,
    this.name,
    this.shotUrls, // Add to constructor
  });

  factory DemoApkLink.fromJson(Map<String, dynamic> json) => DemoApkLink(
    link: json['link'] as String?,
    name: json['name'] as String?,
    shotUrls: (json['shotUrls'] as List<dynamic>?) // Parse nested list
        ?.map((x) => x as String)
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'link': link,
    'name': name,
    'shotUrls': shotUrls, // Add to JSON output
  };
}