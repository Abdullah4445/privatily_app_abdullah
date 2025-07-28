
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privatily_app/admin_launchcode/projects/projects_controller.dart';

import '../models/project_model.dart';
import 'newprojectscreen.dart';

class ProjectScreen extends StatelessWidget {
  final ProjectController controller = Get.put(ProjectController());  // GetX controller

  @override
  Widget build(BuildContext context) {
    // Fetch projects when the screen is initialized
    controller.fetchProjects();

    return Scaffold(
      appBar: AppBar(
        title: Text('Projects List',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        actions: [
          ElevatedButton(onPressed: (){Get.to(AddProjectScreen());}, child:Text("Add New") ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Add filters or other functionality
              },
              child: Text('Filters', style: TextStyle(fontSize: 14,color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Filters button color
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Using Obx to listen to changes in the projects list
          if (controller.projects.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headings Row
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade200,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Name Heading
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Name',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Link Heading
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Link',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Status Heading
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Status',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                // Project List
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.projects.length,
                  itemBuilder: (context, index) {
                    var project = controller.projects[index];
                    return _buildProjectRow(project);  // Custom method to build each row
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Custom method to create a table row
  Widget _buildProjectRow(ProjectModel project) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),  // Margin between rows
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Project title
            Expanded(
              flex: 2,
              child: Text(
                project.title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            // Project Link
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  // Handle link click, navigate or open in browser
                  print('Opening link: ${project.projectLink}');
                },
                child: Text(
                  project.projectLink,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            // Status (Active/Inactive)
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Icon(
                    project.isProjectEnabled
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: project.isProjectEnabled
                        ? Colors.green
                        : Colors.red,
                  ),
                  SizedBox(width: 5),
                  Text(
                    project.isProjectEnabled ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: project.isProjectEnabled
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
