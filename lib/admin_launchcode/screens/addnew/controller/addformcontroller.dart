import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/course.dart';


class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'course';

  // Create or Update a course
  Future<void> saveCourse(CourseModel course) async {
    try {
      // Ensure updatedAt is always set/updated
      // The model's toJson should handle createdAt for new entries with FieldValue.serverTimestamp()
      // and updatedAt for all saves.
      // If you want to explicitly manage updatedAt here before toJson:
      // final courseDataWithTimestamp = course.copyWith(updatedAt: DateTime.now());
      // await _firestore.collection(_collectionPath).doc(course.id).set(courseDataWithTimestamp.toJson());

      // Simpler: Let the model's toJson handle timestamps as configured
      await _firestore.collection(_collectionPath).doc(course.id).set(course.toJson());
    } on FirebaseException catch (e) {
      // Log the error or handle it more gracefully
      print("Firebase error saving course: ${e.code} - ${e.message}");
      // Re-throw a custom exception or the FirebaseException itself
      // to be caught by the UI layer for user feedback.
      throw Exception('Failed to save course: ${e.message}');
    } catch (e) {
      print("Generic error saving course: $e");
      throw Exception('An unexpected error occurred while saving the course.');
    }
  }

  // Fetch a single course by ID (Example - not used in the form directly but good to have)
  Future<CourseModel?> getCourseById(String courseId) async {
    try {
      final docSnapshot = await _firestore.collection(_collectionPath).doc(courseId).get();
      if (docSnapshot.exists) {
        return CourseModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching course: $e");
      return null;
    }
  }

  // Fetch all courses (Example)
  Future<List<CourseModel>> getAllCourses() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionPath).get();
      return querySnapshot.docs
          .map((doc) => CourseModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching all courses: $e");
      return [];
    }
  }

  // Delete a course (Example)
  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection(_collectionPath).doc(courseId).delete();
    } catch (e) {
      print("Error deleting course: $e");
      throw Exception('Failed to delete course.');
    }
  }
}