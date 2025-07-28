import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'project_reviews_logic.dart';

class ProjectReviewsPage extends StatefulWidget {
  const ProjectReviewsPage({Key? key}) : super(key: key);

  @override
  State<ProjectReviewsPage> createState() => _ProjectReviewsPageState();
}

class _ProjectReviewsPageState extends State<ProjectReviewsPage> {
  final ProjectReviewsLogic logic = Get.put(ProjectReviewsLogic());

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Text("Project Reviews")
    );
  }

  @override
  void dispose() {
    Get.delete<ProjectReviewsLogic>();
    super.dispose();
  }
}