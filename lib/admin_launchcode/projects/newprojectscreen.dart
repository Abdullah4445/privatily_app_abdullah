import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:privatily_app/admin_launchcode/projects/projects_controller.dart';
import 'package:uuid/uuid.dart';

import '../models/project_model.dart';

class AddProjectScreen extends StatefulWidget {
  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final ProjectController controller = Get.find<ProjectController>();

  final TextEditingController projectIdController = TextEditingController();
  bool isProjectEnabled = true;
  Uint8List? bytesFromPicker;
  List<Uint8List> pickedImages = []; // List to hold selected images
  List<String> uploadedImageUrls =
      []; // To hold URLs of uploaded images for apk

  List<String> adminUploadedImageUrls =
      []; // To hold URLs of uploaded images for admin
  List<Uint8List> adminImagesLinks = [];

  // Fields for admindemo

  String demoName = "";
  String demoLink = "";
  List<String> adminShortUrls = [];

  // Fields for demoapklinks
  String apkName = "";
  String apklink = "";
  List<String> shortUrls = [];

  //  demoAPKLink
  List<DemoApkLink> demoApkLinks = [];

  // demo admin link

  List<DemoAdminPanelLink> adminApkLinks = [];

  @override
  void initState() {
    super.initState();
    var uuid = Uuid();
    String projectId = uuid.v1(); // Generate a new UUID based on timestamp
    projectIdController.text =
        projectId; // Set the generated project ID to the controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Title Field
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(labelText: 'Project Title'),
              ),
              SizedBox(height: 10),

              // Project Link Field
              TextField(
                controller: controller.linkController,
                decoration: InputDecoration(labelText: 'Project Link'),
              ),
              SizedBox(height: 10),

              TextField(
                controller: controller.demoVideoLink,

                decoration: InputDecoration(labelText: 'Demo Video Link'),
              ),
              SizedBox(height: 10),

              // Description Field
              TextField(
                controller: controller.descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 10),

              // Subtitle Field
              TextField(
                controller: controller.subtitleController,
                decoration: InputDecoration(labelText: 'Subtitle'),
              ),
              SizedBox(height: 10),

              // Price Field
              TextField(
                controller: controller.priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 10),

              // Thumbnail Image Field (single image)
              InkWell(
                onTap: () async {
                  if (kIsWeb) {
                    print("web ");
                    // bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
                    setState(() {});
                  } else if (Platform.isAndroid || Platform.isIOS) {
                    print("Other");
                  }
                },
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.white,
                  child:
                      bytesFromPicker == null
                          ? Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Text("Tab to select \nthumbnail image"),
                            ),
                          )
                          : Image.memory(bytesFromPicker!),
                ),
              ),
              SizedBox(height: 10),

              // APK Name Field
              TextField(
                onChanged: (value) => apkName = value,
                decoration: InputDecoration(labelText: 'APK Name'),
              ),
              SizedBox(height: 10),

              // APK Link Field
              TextField(
                onChanged: (value) => apklink = value,
                decoration: InputDecoration(labelText: 'APK Link'),
              ),
              // Multiple Images Picker Field
              InkWell(
                onTap: () async {
                  if (kIsWeb) {
                    print("web ");
                    List<String> imageUrls = await uploadMultipleImages();
                    print("apk Uploaded image URLs: $imageUrls");
                    setState(() {
                      uploadedImageUrls = imageUrls;
                    });
                  } else if (Platform.isAndroid || Platform.isIOS) {
                    print("Other");
                  }
                },
                child: Container(
                  width: 400,
                  height: 200,
                  color: Colors.grey.shade200,
                  child:
                      pickedImages.isEmpty
                          ? Center(child: Text('Tap to select multiple images'))
                          : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                ),
                            itemCount: pickedImages.length,
                            itemBuilder: (context, index) {
                              return Image.memory(pickedImages[index]);
                            },
                          ),
                ),
              ),
              SizedBox(height: 10),

              // Add APK Link Button
              // Add APK Link Button
              ElevatedButton(
                onPressed: () {
                  if (apkName.isNotEmpty && apklink.isNotEmpty) {
                    demoApkLinks.add(
                      DemoApkLink(
                        name: apkName,
                        apkLink: apklink,
                        shotUrls: uploadedImageUrls, // Use uploaded screenshots
                      ),
                    );
                    setState(() {});
                  }
                },
                child: Text('Add APK Link'),
              ),

              // Admin APK Name Field
              TextField(
                onChanged: (value) => demoName = value,
                decoration: InputDecoration(labelText: 'Demo Name'),
              ),
              SizedBox(height: 10),

              // Admin Link Field
              TextField(
                onChanged: (value) => demoLink = value,
                decoration: InputDecoration(labelText: 'Demo Link'),
              ),
              // admin Multiple Images Picker Field
              InkWell(
                onTap: () async {
                  if (kIsWeb) {
                    print("web ");
                    List<String> adminImageUrls = await demoAdminPanelImages();
                    print("admin Uploaded image URLs: $adminImageUrls");
                    setState(() {
                      adminUploadedImageUrls = adminImageUrls;
                    });
                  } else if (Platform.isAndroid || Platform.isIOS) {
                    print("Other");
                  }
                },
                child: Container(
                  width: 400,
                  height: 200,
                  color: Colors.grey.shade200,
                  child:
                      adminImagesLinks.isEmpty
                          ? Center(child: Text('Tap to select multiple images'))
                          : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                ),
                            itemCount: adminImagesLinks.length,
                            itemBuilder: (context, index) {
                              return Image.memory(adminImagesLinks[index]);
                            },
                          ),
                ),
              ),
              SizedBox(height: 10),

              // Add admin Link Button
              ElevatedButton(
                onPressed: () {
                  if (demoName.isNotEmpty && demoLink.isNotEmpty) {
                    adminApkLinks.add(
                      DemoAdminPanelLink(
                        link: demoLink,
                        name: demoName,
                        shotUrls:
                            adminUploadedImageUrls, // Use uploaded screenshots
                      ),
                    );
                    print(" adminApkLinks${adminApkLinks.length}");
                    setState(() {});
                  }
                },
                child: Text('Add APK Link'),
              ),

              // Team Members Field (Comma separated team member IDs)
              TextField(
                controller: controller.teamMembersController,
                decoration: InputDecoration(
                  labelText: 'Team Members (comma separated)',
                ),
              ),
              SizedBox(height: 10),

              // Project ID Field (Optional)
              TextField(
                controller: projectIdController,
                decoration: InputDecoration(labelText: 'Project ID (Optional)'),
                enabled: false, // Disable editing
              ),
              SizedBox(height: 10),

              // Active Status Toggle
              Row(
                children: [
                  Text('Active'),
                  Switch(
                    value: isProjectEnabled,
                    onChanged: (value) {
                      setState(() {
                        isProjectEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text(" example")),

              // Save Button
              ElevatedButton(
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    Get.snackbar(
                      'Error',
                      'You must be signed in to add a project',
                    );
                    return;
                  }

                  // Upload the thumbnail image
                  String thumbnailUrl = '';
                  if (bytesFromPicker != null) {
                    thumbnailUrl = await UploadthumbnailPic(
                      bytesFromPicker!,
                      "thumbnail/${controller.titleController.text}",
                    );
                  }

                  // Create a new ProjectModel with user inputs
                  ProjectModel newProject = ProjectModel(
                    createdAt: DateTime.now().millisecondsSinceEpoch,
                    demoAdminPanelLinks: adminApkLinks,

                    // shotUrls: uploadedImageUrls,
                    // Store multiple image URLs here
                    // adminShotUrls: adminUploadedImageUrls,
                    demoApkLinks: demoApkLinks,
                    demoDetails: controller.descriptionController.text,
                    demoVideoUrl: controller.demoVideoLink.text,
                    isCustomizationAvailable: true,
                    isProjectEnabled: isProjectEnabled,
                    name: controller.titleController.text,
                    price:
                        double.tryParse(controller.priceController.text) ?? 0.0,
                    projectDesc: controller.descriptionController.text,
                    projectId: projectIdController.text,
                    projectLink: controller.linkController.text,
                    reviews: [],
                    soldCount: 0,
                    subtitle: controller.subtitleController.text,
                    teamMemberIds:
                        controller.teamMembersController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList(),
                    thumbnailUrl: thumbnailUrl,
                    title: controller.titleController.text,
                    updatedAt: null,
                  );

                  // Save the new project to Firestore
                  await controller.saveProjectToFirestore(newProject);

                  Get.snackbar('Success', 'Project added successfully');
                  Get.back(); // Navigate back to previous screen
                },
                child: Text('Save Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to upload the thumbnail image
  Future<String> UploadthumbnailPic(Uint8List image, String folderPath) async {
    String myDownloadUrls = '';
    const String fileName = "thumbnail.jpg";
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child(folderPath)
        .child(fileName);

    try {
      await ref.putData(image);
      myDownloadUrls = await ref.getDownloadURL();
      print("Url of thumbnail: $myDownloadUrls");
    } catch (e) {
      print("Error uploading thumbnail: $e");
    }

    return myDownloadUrls;
  }

  // Method to upload multiple images and get their download URLs
  Future<List<String>> uploadMultipleImages() async {
    List<String> downloadUrls = [];

    // Use image_picker_web to select multiple images as bytes
    // pickedImages = (await ImagePickerWeb.getMultiImagesAsBytes())!;

    // Loop through the picked images and upload them to Firebase Storage
    for (var image in pickedImages) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child("projects/screenshots")
          .child(fileName);

      try {
        await ref.putData(image);
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    return downloadUrls; // Return the list of image download URLs
  }

  //Method to use upload multipleimages and get their urls for Demo Admin panle apk
  Future<List<String>> demoAdminPanelImages() async {
    List<String> adminDownloadUrls = [];

    // Use image_picker_web to select multiple images as bytes
    // adminImagesLinks = (await ImagePickerWeb.getMultiImagesAsBytes())!;

    // Loop through the picked images and upload them to Firebase Storage
    for (var image in adminImagesLinks) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child("projects/screenshots")
          .child(fileName);

      try {
        await ref.putData(image);
        String imagesDownloadUrl = await ref.getDownloadURL();
        adminDownloadUrls.add(imagesDownloadUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    return adminDownloadUrls; // Return the list of image download URLs
  }
}
