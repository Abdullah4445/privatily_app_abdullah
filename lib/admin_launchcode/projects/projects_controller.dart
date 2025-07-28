import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';

class ProjectController extends GetxController {

  // GetX controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController projectIdController = TextEditingController();

  final TextEditingController linkController = TextEditingController();
  final TextEditingController demoVideoLink = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController subtitleController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController thumbnailUrlController = TextEditingController();

  final TextEditingController teamMembersController = TextEditingController();

 // final TextEditingController apkNameController=TextEditingController();
 // final TextEditingController apkLinkController=TextEditingController();

  var projects = <ProjectModel>[].obs;  // Observable list to store projects

  // Fetch projects from Firestore
  Future<void> fetchProjects() async {
    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .get();

      // If data exists, map it to ProjectModel and update the observable list
      if (querySnapshot.docs.isNotEmpty) {
        projects.value = querySnapshot.docs
            .map((doc) => ProjectModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        print("Projects fetched successfully");
      } else {
        print("No projects found");
      }
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }



  // Method to save the project to Firestore with UUID as the document ID
  Future<void> saveProjectToFirestore(ProjectModel newProject) async {
    try {
      await FirebaseFirestore.instance.collection('Students').doc(newProject.projectId).set(newProject.toJson());
    } catch (e) {
      print("Error saving project: $e");
    }
  }






}
