import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:privatily_app/admin_launchcode/screens/students_screen/printableStudentSlip.dart';

import 'Add_student.dart';
import '../../models/students.dart';

// Screens to open on button press
import 'edit_student.dart';
import 'fee_pay.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  // Fetch students from Firestore
  Stream<List<Students>> fetchStudents() {
    return FirebaseFirestore.instance.collection('Students').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Students.fromJson(data);
        }).toList();
      },
    );
  }

  // A custom widget for the status badge
  Widget statusBadge(String? status) {
    Color color;
    String displayStatus;

    if (status == 'Paid') {
      color = Colors.green;
      displayStatus = 'Paid';
    } else if (status == 'Unpaid') {
      color = Colors.red;
      displayStatus = 'Unpaid';
    } else {
      color = Colors.orange;
      displayStatus = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Center(
        child: Text(
          displayStatus,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Function to show fee history dialog
  void _showFeeHistoryDialog(BuildContext context, Students student) {
    if (student.feeHistory != null && student.feeHistory!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Fee History"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: student.feeHistory!.length,
              itemBuilder: (context, feeIndex) {
                final fee = student.feeHistory![feeIndex];
                return ListTile(
                  leading: Icon(Icons.payment,
                      color: fee['status'] == 'Paid'
                          ? Colors.green
                          : fee['status'] == 'Unpaid'
                          ? Colors.red
                          : Colors.orange),
                  title: Text("Date: ${fee['date'] ?? 'N/A'}"),
                  subtitle: Text(
                      "Amount: ${fee['amount'] ?? 'N/A'} • Status: ${fee['status'] ?? 'N/A'}"),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    } else {
      Get.snackbar(
        "No Fee History",
        "No fee record available for this student.",
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: AppBar(
        title: const Text('Students List'),
        backgroundColor: Colors.green.shade700,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green.shade700,
              ),
              onPressed: () => Get.to(() => const AddStudentScreen()),
              icon: const Icon(Icons.add),
              label: const Text("Add New"),
            ),
          )
        ],
      ),
      body: StreamBuilder<List<Students>>(
        stream: fetchStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No students found."));
          }

          final students = snapshot.data!;

          // Using LayoutBuilder to make the UI responsive
          return LayoutBuilder(
            builder: (context, constraints) {
              // For wide screens, show a table view
              if (constraints.maxWidth > 600) {
                return _buildWideLayout(students);
              }
              // For narrow screens, show a list of cards
              else {
                return _buildNarrowLayout(context, students);
              }
            },
          );
        },
      ),
    );
  }

  // WIDE LAYOUT FOR TABLETS/DESKTOPS
  Widget _buildWideLayout(List<Students> students) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Table Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: const [
                Expanded(flex: 1, child: Text('No.', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('Roll No', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('Class', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('Fee Status', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 4, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black54),
          // Students List
          Expanded(
            child: ListView.separated(
              itemCount: students.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = students[index];
                final latestFeeStatus = student.feeHistory?.isNotEmpty == true
                    ? student.feeHistory!.last['status']
                    : 'Unknown';

                return Container(
                  color: index % 2 == 0 ? Colors.white : Colors.grey.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Text('${index + 1}')),
                      Expanded(flex: 3, child: Text(student.name)),
                      Expanded(flex: 3, child: Text(student.rollNo ?? '', overflow: TextOverflow.ellipsis)),
                      Expanded(flex: 3, child: Text(student.className ?? '', overflow: TextOverflow.ellipsis)),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _showFeeHistoryDialog(context, student),
                          child: Tooltip(
                            message: "Tap to view full fee history",
                            child: statusBadge(latestFeeStatus),
                          ),
                        ),
                      ),
                      // Action Buttons
                      Expanded(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), tooltip: "Edit Details", onPressed: () => Get.to(() => EditStudentScreen(student: student)), splashRadius: 20),
                            IconButton(icon: const Icon(Icons.attach_money, color: Colors.green), tooltip: "Pay Fee", onPressed: () => Get.to(() => FeePaymentScreen(student: student)), splashRadius: 20),
                            IconButton(icon: const Icon(Icons.print, color: Colors.grey), tooltip: "Print Fee Slip", onPressed: () => Get.to(() => PrintableStudentSlip(student: student)), splashRadius: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // NARROW LAYOUT FOR MOBILE PHONES
  Widget _buildNarrowLayout(BuildContext context, List<Students> students) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        final latestFeeStatus = student.feeHistory?.isNotEmpty == true
            ? student.feeHistory!.last['status']
            : 'Unknown';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with Name and Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        student.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showFeeHistoryDialog(context, student),
                      child: Tooltip(
                        message: "Tap to view full fee history",
                        child: statusBadge(latestFeeStatus),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                // Details
                Text("Roll No: ${student.rollNo ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text("Class: ${student.className ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      label: const Text("Edit"),
                      onPressed: () => Get.to(() => EditStudentScreen(student: student)),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.attach_money, color: Colors.green),
                      label: const Text("Pay"),
                      onPressed: () => Get.to(() => FeePaymentScreen(student: student)),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.print, color: Colors.grey.shade600),
                      label: const Text("Print"),
                      onPressed: () => Get.to(() => PrintableStudentSlip(student: student)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}