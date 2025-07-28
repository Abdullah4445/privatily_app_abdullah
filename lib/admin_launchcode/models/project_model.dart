

class ProjectModel {
  int createdAt;
  List<DemoAdminPanelLink> demoAdminPanelLinks;
  // List<String> shotUrls;
  // List<String> adminShotUrls;
  List<DemoApkLink> demoApkLinks;
  String demoDetails;
  String demoVideoUrl;
  bool isCustomizationAvailable;
  bool isProjectEnabled;
  String name;
  double price;
  String projectDesc;
  String projectId;
  String projectLink;
  List<String> reviews;
  int soldCount;
  String subtitle;
  List<String> teamMemberIds;
  String thumbnailUrl;
  String title;
  dynamic updatedAt;

  ProjectModel({
    required this.createdAt,
    required this.demoAdminPanelLinks,
    // required this.shotUrls,
    // required this.adminShotUrls,

    required this.demoApkLinks,
    required this.demoDetails,
    required this.demoVideoUrl,
    required this.isCustomizationAvailable,
    required this.isProjectEnabled,
    required this.name,
    required this.price,
    required this.projectDesc,
    required this.projectId,
    required this.projectLink,
    required this.reviews,
    required this.soldCount,
    required this.subtitle,
    required this.teamMemberIds,
    required this.thumbnailUrl,
    required this.title,
    this.updatedAt,
  });

  // Factory method to create a ProjectModel from JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    createdAt: json['createdAt'] ?? 0,
    demoAdminPanelLinks: json['demoAdminPanelLinks'] != null
        ? List<DemoAdminPanelLink>.from(json['demoAdminPanelLinks'].map((x) => DemoAdminPanelLink.fromJson(x)))
        : [],
    // shotUrls: json['shotUrls'] != null
    //     ? List<String>.from(json['shotUrls'].map((x) => x))
    //     : [],
    // adminShotUrls: json['AdminShotUrls'] != null
    //     ? List<String>.from(json['AdminShotUrls'].map((x) => x))
    //     : [],
    demoApkLinks: json['demoApkLinks'] != null
        ? List<DemoApkLink>.from(json['demoApkLinks'].map((x) => DemoApkLink.fromJson(x)))
        : [],
    demoDetails: json['demoDetails'] ?? '',
    demoVideoUrl: json['demoVideoUrl'] ?? '',
    isCustomizationAvailable: json['isCustomizationAvailable'] ?? false,
    isProjectEnabled: json['isProjectEnabled'] ?? false,
    name: json['name'] ?? '',
    price: json['price']?.toDouble() ?? 0.0,
    projectDesc: json['projectDesc'] ?? '',
    projectId: json['projectId'] ?? '',
    projectLink: json['projectLink'] ?? '',
    reviews: json['reviews'] != null
        ? List<String>.from(json['reviews'].map((x) => x))
        : [],
    soldCount: json['soldCount'] ?? 0,
    subtitle: json['subtitle'] ?? '',
    teamMemberIds: json['teamMemberIds'] != null
        ? List<String>.from(json['teamMemberIds'].map((x) => x))
        : [],
    thumbnailUrl: json['thumbnailUrl'] ?? '',
    title: json['title'] ?? '',
    updatedAt: json['updatedAt'],
  );

  // Method to convert ProjectModel to JSON
  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'demoAdminPanelLinks': List<dynamic>.from(demoAdminPanelLinks.map((x) => x.toJson())),
    // 'shotUrls': List<dynamic>.from(shotUrls.map((x) => x)),
    // 'adminShotUrls': List<dynamic>.from(adminShotUrls.map((x) => x)),
    'demoApkLinks': List<dynamic>.from(demoApkLinks.map((x) => x.toJson())),
    'demoDetails': demoDetails,
    'demoVideoUrl': demoVideoUrl,
    'isCustomizationAvailable': isCustomizationAvailable,
    'isProjectEnabled': isProjectEnabled,
    'name': name,
    'price': price,
    'projectDesc': projectDesc,
    'projectId': projectId,
    'projectLink': projectLink,
    'reviews': List<dynamic>.from(reviews.map((x) => x)),
    'soldCount': soldCount,
    'subtitle': subtitle,
    'teamMemberIds': List<dynamic>.from(teamMemberIds.map((x) => x)),
    'thumbnailUrl': thumbnailUrl,
    'title': title,
    'updatedAt': updatedAt,
  };
}

// Define the DemoApkLink class with subfields
class DemoApkLink {
  String name;
  String apkLink;
  List<String> shotUrls;

  DemoApkLink({
    required this.name,
    required this.apkLink,
    required this.shotUrls,
  });

  factory DemoApkLink.fromJson(Map<String, dynamic> json) => DemoApkLink(
    name: json['name'] ?? '',
    apkLink: json['apkLink'] ?? '',
    shotUrls: json['shotUrls'] != null
        ? List<String>.from(json['shotUrls'].map((x) => x))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'apkLink': apkLink,
    'shotUrls': List<dynamic>.from(shotUrls.map((x) => x)),
  };
}

// Similar for DemoAdminPanelLink class with a `name`, `link` and `shotUrls`
class DemoAdminPanelLink {
  String name;
  String link;
  List<String> shotUrls;

  DemoAdminPanelLink({
    required this.name,
    required this.link,
    required this.shotUrls,
  });

  factory DemoAdminPanelLink.fromJson(Map<String, dynamic> json) => DemoAdminPanelLink(
    name: json['name'] ?? '',
    link: json['link'] ?? '',
    shotUrls: json['shotUrls'] != null
        ? List<String>.from(json['shotUrls'].map((x) => x))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'link': link,
    'shotUrls': List<dynamic>.from(shotUrls.map((x) => x)),
  };
}


