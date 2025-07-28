import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/course.dart';
import 'controller/addformcontroller.dart';


//  comment
class CourseFormScreen extends StatefulWidget {
  final CourseModel? courseToEdit;

  const CourseFormScreen({Key? key, this.courseToEdit}) : super(key: key);

  @override
  _CourseFormScreenState createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseService = CourseService(); // Instantiate your service
  final _uuid = Uuid();

  // Text Editing Controllers (same as before)
  late TextEditingController _nameController;
  late TextEditingController _durationController;
  late TextEditingController _feeController;
  late TextEditingController _descriptionController;
  late TextEditingController _instructorController;
  late TextEditingController _thumbnailUrlController;
  late TextEditingController _categoryController;
  late TextEditingController _languageController;
  late TextEditingController _levelController;
  late TextEditingController _contentsController;
  late TextEditingController _notesController;
  late TextEditingController _audioUrlsController;
  late TextEditingController _videoUrlsController;
  late TextEditingController _tagsController;
  late TextEditingController _prerequisitesController;

  bool _isPublished = false;
  bool _isLoading = false;
  String? _courseId;

  @override
  void initState() {
    super.initState();
    final course = widget.courseToEdit;
    _courseId = course?.id ?? _uuid.v4();

    // Initialize controllers (same as before)
    _nameController = TextEditingController(text: course?.name ?? '');
    _durationController = TextEditingController(text: course?.duration.toString() ?? '');
    _feeController = TextEditingController(text: course?.fee.toString() ?? '');
    _descriptionController = TextEditingController(text: course?.description ?? '');
    _instructorController = TextEditingController(text: course?.instructor ?? '');
    _thumbnailUrlController = TextEditingController(text: course?.thumbnailUrl ?? '');
    _categoryController = TextEditingController(text: course?.category ?? '');
    _languageController = TextEditingController(text: course?.language?.join(',') ?? '');
    _levelController = TextEditingController(text: course?.level ?? '');
    _contentsController = TextEditingController(text: course?.contents.join(', ') ?? '');
    _notesController = TextEditingController(text: course?.notes.join(', ') ?? '');
    _audioUrlsController = TextEditingController(text: course?.audioUrls.join(', ') ?? '');
    _videoUrlsController = TextEditingController(text: course?.videoUrls.join(', ') ?? '');
    _tagsController = TextEditingController(text: course?.tags?.join(', ') ?? '');
    _prerequisitesController = TextEditingController(text: course?.prerequisites?.join(', ') ?? '');
    _isPublished = course?.isPublished ?? false;
  }

  @override
  void dispose() {
    // Dispose controllers (same as before)
    _nameController.dispose();
    _durationController.dispose();
    _feeController.dispose();
    _descriptionController.dispose();
    _instructorController.dispose();
    _thumbnailUrlController.dispose();
    _categoryController.dispose();
    _languageController.dispose();
    _levelController.dispose();
    _contentsController.dispose();
    _notesController.dispose();
    _audioUrlsController.dispose();
    _videoUrlsController.dispose();
    _tagsController.dispose();
    _prerequisitesController.dispose();
    super.dispose();
  }

  List<String> _splitStringToList(String? text) {
    if (text == null || text.trim().isEmpty) return [];
    return text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  Future<void> _submitCourseForm() async { // Renamed from _saveCourse for clarity
    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if form is invalid
    }

    setState(() {
      _isLoading = true;
    });

    // Create the CourseModel instance from form data
    final now = DateTime.now();
    final courseData = CourseModel(
      id: _courseId!,
      name: _nameController.text.trim(),
      duration: double.tryParse(_durationController.text.trim()) ?? 0.0,
      fee: int.tryParse(_feeController.text.trim()) ?? 0,
      contents: _splitStringToList(_contentsController.text),
      notes: _splitStringToList(_notesController.text),
      audioUrls: _splitStringToList(_audioUrlsController.text),
      videoUrls: _splitStringToList(_videoUrlsController.text),
      thumbnailUrl: _thumbnailUrlController.text.trim().isEmpty ? null : _thumbnailUrlController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      instructor: _instructorController.text.trim().isEmpty ? null : _instructorController.text.trim(),
      tags: _splitStringToList(_tagsController.text),
      // Let the model's toJson handle server timestamps for new entries or pass explicit dates
      createdAt: widget.courseToEdit?.createdAt, // Preserve original if editing
      updatedAt: now, // Always set/update this for the save operation. Model's toJson will handle formatting.
      isPublished: _isPublished,
      enrolledUsers: widget.courseToEdit?.enrolledUsers ?? [],
      rating: widget.courseToEdit?.rating,
      totalRatings: widget.courseToEdit?.totalRatings,
      category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
      language:_splitStringToList(_languageController.text),
      level: _levelController.text.trim().isEmpty ? null : _levelController.text.trim(),
      prerequisites: _splitStringToList(_prerequisitesController.text),
      progressMap: widget.courseToEdit?.progressMap ?? {},
    );

    try {
      // Use the service to save the course
      await _courseService.saveCourse(courseData);

      if (mounted) { // Check if widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.courseToEdit == null ? 'Course added successfully!' : 'Course updated successfully!')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true); // Pop and indicate success
        }
      }
    } catch (e) {
      if (mounted) { // Check if widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save course: ${e.toString()}')), // Show error from service
        );
      }
    } finally {
      if (mounted) { // Check if widget is still in the tree
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // _buildTextField and _buildListTextField helper methods (same as before)
  Widget _buildTextField(TextEditingController controller, String label, {TextInputType? keyboardType, bool isOptional = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (!isOptional && (value == null || value.trim().isEmpty)) {
            return 'Please enter $label';
          }
          if (keyboardType == TextInputType.numberWithOptions(decimal: true) || keyboardType == TextInputType.number) {
            if (value != null && value.isNotEmpty && num.tryParse(value) == null) {
              return 'Please enter a valid number for $label';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildListTextField(TextEditingController controller, String label, {bool isOptional = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$label (comma-separated)',
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.trim().isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseToEdit == null ? 'Add New Course' : 'Edit Course'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: Colors.white),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _submitCourseForm, // Use the renamed method
              tooltip: 'Save Course',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView( // Your form fields (same as before)
            children: <Widget>[
              Text("Course ID: $_courseId", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 10),
              _buildTextField(_nameController, 'Course Name'),
              _buildTextField(_durationController, 'Duration (hours)', keyboardType: TextInputType.numberWithOptions(decimal: true)),
              _buildTextField(_feeController, 'Fee', keyboardType: TextInputType.number),
              _buildTextField(_descriptionController, 'Description', isOptional: true, maxLines: 3),
              _buildTextField(_instructorController, 'Instructor', isOptional: true),
              _buildTextField(_thumbnailUrlController, 'Thumbnail URL', isOptional: true, keyboardType: TextInputType.url),
              _buildTextField(_categoryController, 'Category', isOptional: true),
              _buildTextField(_languageController, 'Language', isOptional: true),
              _buildTextField(_levelController, 'Level (e.g., Beginner, Intermediate)', isOptional: true),

              SizedBox(height: 16),
              Text("Course Materials (comma-separated):", style: Theme.of(context).textTheme.titleMedium),
              _buildListTextField(_contentsController, 'Contents', isOptional: false),
              _buildListTextField(_notesController, 'Notes', isOptional: false),
              _buildListTextField(_audioUrlsController, 'Audio URLs', isOptional: false),
              _buildListTextField(_videoUrlsController, 'Video URLs', isOptional: false),
              _buildListTextField(_tagsController, 'Tags'),
              _buildListTextField(_prerequisitesController, 'Prerequisites'),


              SwitchListTile(
                title: Text('Is Published?'),
                value: _isPublished,
                onChanged: (bool value) {
                  setState(() {
                    _isPublished = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitCourseForm,
                child: _isLoading ? CircularProgressIndicator(color: Colors.white,) : Text(widget.courseToEdit == null ? 'Add Course' : 'Update Course'),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: TextStyle(fontSize: 18)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}