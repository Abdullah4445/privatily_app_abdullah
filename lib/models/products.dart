

// --- Main Project Model ---
class Project {
  final int? createdAt; // Consider using DateTime after parsing
  final List<DemoAdminPanelLink>? demoAdminPanelLinks;
  final List<String>? mobileShotUrls; // Top-level screenshots (renamed for clarity)
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
  final dynamic updatedAt; // Keep dynamic or parse to DateTime/Timestamp if needed

  Project({
    this.createdAt,
    this.demoAdminPanelLinks,
    this.mobileShotUrls, // Corresponds to the top-level 'shotUrls' in JSON
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

  // Helper Getters for easier access to specific screenshot lists
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

  List<String> get mobileAppScreenshots {
    // Returns the top-level list if it exists
    return mobileShotUrls ?? [];
  }

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


  factory Project.fromJson(Map<String, dynamic> json) => Project(
    createdAt: json['createdAt'] as int?,
    demoAdminPanelLinks: (json['demoAdminPanelLinks'] as List<dynamic>?)
        ?.map((x) => DemoAdminPanelLink.fromJson(x as Map<String, dynamic>))
        .toList(),
    // Map the top-level 'shotUrls' from JSON to 'mobileShotUrls' in the model
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
    updatedAt: json['updatedAt'], // Keep as dynamic
  );

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'demoAdminPanelLinks': demoAdminPanelLinks?.map((x) => x.toJson()).toList(),
    // Map 'mobileShotUrls' back to 'shotUrls' key in JSON
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