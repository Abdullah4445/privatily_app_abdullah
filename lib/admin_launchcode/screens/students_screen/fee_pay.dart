import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../models/students.dart';

class FeePaymentScreen extends StatefulWidget {
  final Students student;
  const FeePaymentScreen({super.key, required this.student});

  @override
  State<FeePaymentScreen> createState() => _FeePaymentScreenState();
}

class _FeePaymentScreenState extends State<FeePaymentScreen> {
  DateTime? selectedMonth;
  DateTime? paidDate;
  final amountController = TextEditingController();
  String feeStatus = 'Paid';

  void pickMonth() async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedMonth = picked);
    }
  }

  void pickPaidDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => paidDate = picked);
    }
  }

  void addFeeEntry() async {
    if (selectedMonth == null || paidDate == null || amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final newFee = {
      'date': "${selectedMonth!.year}-${selectedMonth!.month.toString().padLeft(2, '0')}",
      'amount': amountController.text.trim(),
      'status': feeStatus,
      'paidDate': "${paidDate!.year}-${paidDate!.month.toString().padLeft(2, '0')}-${paidDate!.day.toString().padLeft(2, '0')}",
    };

    List<Map<String, dynamic>> updatedHistory = widget.student.feeHistory ?? [];
    updatedHistory.add(newFee);

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(widget.student.id)
        .update({'feeHistory': updatedHistory});

    setState(() {
      amountController.clear();
      selectedMonth = null;
      paidDate = null;
      feeStatus = 'Paid';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fee entry added")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = widget.student.feeHistory ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Fee Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickMonth,
              child: Text(
                selectedMonth == null
                    ? "Select Month"
                    : "Month: ${selectedMonth!.month}/${selectedMonth!.year}",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickPaidDate,
              child: Text(
                paidDate == null
                    ? "Select Paid Date"
                    : "Paid on: ${paidDate!.day}/${paidDate!.month}/${paidDate!.year}",
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Fee Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: feeStatus,
              decoration: const InputDecoration(
                labelText: 'Fee Status',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => feeStatus = val!),
              items: ['Paid', 'Unpaid', 'Partial'].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: addFeeEntry,
              child: const Text("Add Fee Entry"),
            ),
            const Divider(height: 30),
            const Text("Previous Fee History", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final fee = history[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_today,
                          color: fee['status'] == 'Paid'
                              ? Colors.green
                              : fee['status'] == 'Unpaid'
                              ? Colors.red
                              : Colors.orange),
                      title: Text("Month: ${fee['date'] ?? 'N/A'}"),
                      subtitle: Text(
                          "Amount: ${fee['amount']} • Status: ${fee['status']} \nPaid On: ${fee['paidDate'] ?? 'N/A'}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
