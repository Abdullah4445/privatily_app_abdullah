// lib/modules/project_comments/project_comments_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/project_model.dart';
import '../../projects/projects_controller.dart';

class ProjectCommentsLogic extends GetxController {
  // --------------------------------------------------------------------------
  final _fire = FirebaseFirestore.instance;
  final _projects = Get.find<ProjectController>();

  /// currently selected project in the dropdown
  final Rx<ProjectModel?> selectedProject = Rx<ProjectModel?>(null);

  // --------------------------------------------------------------------------
  // STREAMS
  // --------------------------------------------------------------------------

  /// live list of comments for the selected project
  Stream<QuerySnapshot>? get commentStream => selectedProject.value == null
      ? null
      : _fire
      .collection('project_comments')
      .where('projectId', isEqualTo: selectedProject.value!.projectId)
      // .orderBy('createdAt', descending: false) // oldest first
      .snapshots();

  /// live thread (replies) for **one** parent comment
  Stream<QuerySnapshot> threadStream(String commentDocId) => _fire
      .collection('project_comments')
      .doc(commentDocId)
      .collection('thread')
      .orderBy('sentAt', descending: true) // newest on top in the sheet
      .snapshots();

  // --------------------------------------------------------------------------
  // CRUD HELPERS
  // --------------------------------------------------------------------------

  /// user changed the project in the dropdown
  void changeProject(ProjectModel project) => selectedProject.value = project;

  /// create a *root* comment (pretend to be the customer)
  Future<bool> addComment({
    required String username,
    required String comment,
    required bool purchased,
  }) async {
    final proj = selectedProject.value;
    if (proj == null) return false;

    try {
      await _fire.collection('project_comments').add({
        'projectId': proj.projectId,
        'username': username,
        'comment': comment,
        'purchased': purchased,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  /// add one message to the thread (either side)
  Future<void> addThreadMessage({
    required String commentDocId,
    required String sender,
    required String text,
  }) async {
    await _fire
        .collection('project_comments')
        .doc(commentDocId)
        .collection('thread')
        .add({
      'sender': sender,
      'text': text,
      'sentAt': FieldValue.serverTimestamp(),
    });
  }

  /// delete a parent comment **and** every message in its thread
  Future<void> deleteComment(String commentDocId) async {
    try {
      // 1) gather thread docs
      final threadRef = _fire
          .collection('project_comments')
          .doc(commentDocId)
          .collection('thread');
      final threadDocs = await threadRef.get();

      // 2) batch delete: thread docs + parent doc
      final batch = _fire.batch();
      for (var d in threadDocs.docs) {
        batch.delete(d.reference);
      }
      batch.delete(
          _fire.collection('project_comments').doc(commentDocId));

      await batch.commit();
      Get.snackbar('Deleted', 'Comment and thread removed');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // --------------------------------------------------------------------------
  @override
  void onInit() {
    // default-select the first project (if already fetched by ProjectController)
    if (_projects.projects.isNotEmpty) {
      selectedProject.value = _projects.projects.first;
    }
    super.onInit();
  }
}
