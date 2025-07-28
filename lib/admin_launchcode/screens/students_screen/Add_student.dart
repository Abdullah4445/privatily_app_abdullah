import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/students.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  // All Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final rollNoController = TextEditingController();
  final classNameController = TextEditingController();
  final sectionController = TextEditingController();
  final contactController = TextEditingController();
  final feeAmountController = TextEditingController(); // updated
  final attendanceController = TextEditingController();
  final addressController = TextEditingController();
  final guardianNameController = TextEditingController();

  final parentNameController = TextEditingController();
  final parentContactController = TextEditingController();
  final parentOccupationController = TextEditingController();
  final parentAddressController = TextEditingController();
  final relationshipController = TextEditingController();

  final courseListController = TextEditingController();

  String feeStatus = 'Unpaid'; // now stores fee status for fee history

  void saveToFirestore() async {
    if (_formKey.currentState!.validate()) {
      final docRef = FirebaseFirestore.instance.collection('Students').doc();

      final now = DateTime.now();
      final student = Students(
        name: nameController.text.trim(),
        id: docRef.id,
        createdAt: now.microsecondsSinceEpoch,
        email: emailController.text.trim(),
        rollNo: rollNoController.text.trim(),
        className: classNameController.text.trim(),
        section: sectionController.text.trim(),
        contact: contactController.text.trim(),
        fee: feeAmountController.text.trim(), // initial amount
        attendance: attendanceController.text.trim(),
        address: addressController.text.trim(),
        guardianName: guardianNameController.text.trim(),
        parentName: parentNameController.text.trim(),
        parentContact: parentContactController.text.trim(),
        parentOccupation: parentOccupationController.text.trim(),
        parentAddress: parentAddressController.text.trim(),
        relationship: relationshipController.text.trim(),
        courseList: courseListController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),

        // ✅ Save initial fee as feeHistory
        feeHistory: [
          {
            'date': now.toIso8601String(),
            'amount': feeAmountController.text.trim(),
            'status': feeStatus,
          }
        ],
      );

      await docRef.set(student.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student Saved Successfully')),
      );

      _formKey.currentState!.reset();
    }
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Student')),
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

              // ✅ Replace Fee field with amount + status
              buildTextField('Fee Amount', feeAmountController),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Fee Status',
                  border: OutlineInputBorder(),
                ),
                value: feeStatus,
                onChanged: (val) => setState(() => feeStatus = val!),
                items: ['Paid', 'Unpaid', 'Partial'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
              ),

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

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveToFirestore,
                child: Text('Save Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
