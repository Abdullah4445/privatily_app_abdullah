import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/students.dart';

class EditStudentScreen extends StatefulWidget {
  final Students student;
  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController rollNoController;
  late TextEditingController classNameController;
  late TextEditingController sectionController;
  late TextEditingController contactController;
  late TextEditingController attendanceController;
  late TextEditingController addressController;
  late TextEditingController guardianNameController;
  late TextEditingController parentNameController;
  late TextEditingController parentContactController;
  late TextEditingController parentOccupationController;
  late TextEditingController parentAddressController;
  late TextEditingController relationshipController;
  late TextEditingController courseListController;

  // New fee entry controllers
  final TextEditingController newFeeAmountController = TextEditingController();
  String newFeeStatus = 'Paid';
  String todayDate = DateTime.now().toString().split(' ')[0];

  @override
  void initState() {
    super.initState();
    final s = widget.student;

    nameController = TextEditingController(text: s.name);
    emailController = TextEditingController(text: s.email);
    rollNoController = TextEditingController(text: s.rollNo);
    classNameController = TextEditingController(text: s.className);
    sectionController = TextEditingController(text: s.section);
    contactController = TextEditingController(text: s.contact);
    attendanceController = TextEditingController(text: s.attendance);
    addressController = TextEditingController(text: s.address);
    guardianNameController = TextEditingController(text: s.guardianName);

    parentNameController = TextEditingController(text: s.parentName);
    parentContactController = TextEditingController(text: s.parentContact);
    parentOccupationController = TextEditingController(text: s.parentOccupation);
    parentAddressController = TextEditingController(text: s.parentAddress);
    relationshipController = TextEditingController(text: s.relationship);
    courseListController = TextEditingController(text: (s.courseList ?? []).join(', '));
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  void updateStudent() async {
    if (_formKey.currentState!.validate()) {
      final docRef = FirebaseFirestore.instance.collection('Students').doc(widget.student.id);

      List<Map<String, dynamic>> updatedFeeHistory = widget.student.feeHistory ?? [];

      if (newFeeAmountController.text.trim().isNotEmpty) {
        updatedFeeHistory.add({
          'amount': newFeeAmountController.text.trim(),
          'status': newFeeStatus,
          'date': todayDate,
        });
      }

      final updatedStudent = Students(
        name: nameController.text.trim(),
        id: widget.student.id,
        createdAt: widget.student.createdAt,
        email: emailController.text.trim(),
        rollNo: rollNoController.text.trim(),
        className: classNameController.text.trim(),
        section: sectionController.text.trim(),
        contact: contactController.text.trim(),
        attendance: attendanceController.text.trim(),
        address: addressController.text.trim(),
        guardianName: guardianNameController.text.trim(),
        parentName: parentNameController.text.trim(),
        parentContact: parentContactController.text.trim(),
        parentOccupation: parentOccupationController.text.trim(),
        parentAddress: parentAddressController.text.trim(),
        relationship: relationshipController.text.trim(),
        courseList: courseListController.text.split(',').map((e) => e.trim()).toList(),
        feeHistory: updatedFeeHistory,
      );

      await docRef.update(updatedStudent.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student updated successfully")),
      );

      Navigator.pop(context); // Back to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField('Student Name', nameController),
              buildTextField('Email', emailController),
              buildTextField('Roll No', rollNoController),
              buildTextField('Class', classNameController),
              buildTextField('Section', sectionController),
              buildTextField('Contact', contactController),
              buildTextField('Attendance (%)', attendanceController),
              buildTextField('Address', addressController),
              buildTextField('Guardian Name', guardianNameController),

              const Divider(height: 30),
              const Text("Parent Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              buildTextField('Parent Name', parentNameController),
              buildTextField('Parent Contact', parentContactController),
              buildTextField('Parent Occupation', parentOccupationController),
              buildTextField('Parent Address', parentAddressController),
              buildTextField('Relationship', relationshipController),

              const Divider(height: 30),
              const Text("Courses", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              buildTextField('Courses (comma separated)', courseListController),

              const Divider(height: 30),
              const Text("Add New Fee Entry", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              buildTextField('Fee Amount', newFeeAmountController),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Fee Status',
                  border: OutlineInputBorder(),
                ),
                value: newFeeStatus,
                onChanged: (val) => setState(() => newFeeStatus = val!),
                items: ['Paid', 'Unpaid', 'Partial'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
              ),
              const SizedBox(height: 8),
              Text("Date: $todayDate", style: const TextStyle(color: Colors.grey)),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateStudent,
                child: const Text('Update Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
