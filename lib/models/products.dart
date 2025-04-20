class Project {
  List<dynamic>? comments;
  int? createdAt;
  List<DemoAdminPanelLink>? demoAdminPanelLinks;
  List<String>? shotUrls;
  List<DemoApkLink>? demoApkLinks;
  String? demoDetails;
  String? demoVideoUrl;
  bool? isCustomizationAvailable;
  bool? isProjectEnabled;
  String? name;
  int? price; // Assuming price is integer like $29
  String? projectDesc;
  String? projectId;
  String? projectLink;
  List<dynamic>? reviews;
  int? soldCount;
  String? subtitle;
  List<dynamic>? teamMemberIds;
  String? thumbnailUrl;
  String? title;
  dynamic updatedAt;
  // --- New Fields Added ---
  double? rating; // Average rating value (e.g., 4.5)
  int? ratingCount; // Number of ratings (e.g., 10)
  // --- End New Fields ---


  Project({
    this.comments,
    this.createdAt,
    this.demoAdminPanelLinks,
    this.shotUrls,
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
    // --- Added to Constructor ---
    this.rating,
    this.ratingCount,
    // --- End Constructor Update ---
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    comments: json['comments'] == null ? [] : List<dynamic>.from(json['comments'] ?? []),
    createdAt: json['createdAt'],
    demoAdminPanelLinks: (json['demoAdminPanelLinks'] as List<dynamic>?)
        ?.map((e) => DemoAdminPanelLink.fromJson(e as Map<String, dynamic>))
        .toList(),
    shotUrls: json['shotUrls'] == null ? [] : List<String>.from(json['shotUrls'] ?? []),
    demoApkLinks: (json['demoApkLinks'] as List<dynamic>?)
        ?.map((e) => DemoApkLink.fromJson(e as Map<String, dynamic>))
        .toList(),
    demoDetails: json['demoDetails'],
    demoVideoUrl: json['demoVideoUrl'],
    isCustomizationAvailable: json['isCustomizationAvailable'],
    isProjectEnabled: json['isProjectEnabled'],
    name: json['name'],
    // Ensure price is parsed as int, handle potential double/string from JSON if needed
    price: (json['price'] as num?)?.toInt(),
    projectDesc: json['projectDesc'],
    projectId: json['projectId'],
    projectLink: json['projectLink'],
    reviews: json['reviews'] == null ? [] : List<dynamic>.from(json['reviews'] ?? []),
    soldCount: json['soldCount'],
    subtitle: json['subtitle'],
    teamMemberIds: json['teamMemberIds'] == null ? [] : List<dynamic>.from(json['teamMemberIds'] ?? []),
    thumbnailUrl: json['thumbnailUrl'],
    title: json['title'],
    updatedAt: json['updatedAt'],
    // --- Added to fromJson ---
    // Safely parse rating as double (handles int or double in JSON)
    rating: (json['rating'] as num?)?.toDouble(),
    ratingCount: json['ratingCount'], // Assuming ratingCount is directly an int?
    // --- End fromJson Update ---
  );

  Map<String, dynamic> toJson() => {
    'comments': comments,
    'createdAt': createdAt,
    'demoAdminPanelLinks': demoAdminPanelLinks?.map((e) => e.toJson()).toList(),
    'shotUrls': shotUrls,
    'demoApkLinks': demoApkLinks?.map((e) => e.toJson()).toList(),
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
    // --- Added to toJson ---
    'rating': rating,
    'ratingCount': ratingCount,
    // --- End toJson Update ---
  };
}

// --- Dummy classes for DemoAdminPanelLink and DemoApkLink ---
// Replace these with your actual class definitions if they exist
class DemoAdminPanelLink {
  // Example properties - replace with actual ones
  String? url;
  String? username;
  String? password;

  DemoAdminPanelLink({this.url, this.username, this.password});

  factory DemoAdminPanelLink.fromJson(Map<String, dynamic> json) => DemoAdminPanelLink(
    url: json['url'],
    username: json['username'],
    password: json['password'],
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'username': username,
    'password': password,
  };
}

class DemoApkLink {
  // Example property - replace with actual one
  String? url;

  DemoApkLink({this.url});

  factory DemoApkLink.fromJson(Map<String, dynamic> json) => DemoApkLink(
    url: json['url'],
  );

  Map<String, dynamic> toJson() => {
    'url': url,
  };
}
// --- End Dummy Classes ---