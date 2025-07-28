import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/students.dart';

class PrintableStudentSlip extends StatefulWidget {
  final Students student;

  const PrintableStudentSlip({super.key, required this.student});

  @override
  State<PrintableStudentSlip> createState() => _PrintableStudentSlipState();
}

class _PrintableStudentSlipState extends State<PrintableStudentSlip> {
  DateTime? selectedMonth;
  DateTime? paidDate;
  final TextEditingController amountController = TextEditingController();
  String feeStatus = 'Paid';
  Map<String, dynamic>? _lastSavedFee;
  bool _showHistory = false;

  void pickMonth() async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => selectedMonth = picked);
  }

  void pickPaidDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => paidDate = picked);
  }

  void addFeeEntry(String studentId, List<Map<String, dynamic>> history) async {
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

    history.add(newFee);

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(studentId)
        .update({'feeHistory': history});

    setState(() {
      _lastSavedFee = newFee;
      amountController.clear();
      selectedMonth = null;
      paidDate = null;
      feeStatus = 'Paid';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fee entry added. Ready to print.")),
    );
  }

  Future<Uint8List> _createPdf(PdfPageFormat format, {Map<String, dynamic>? feeToPrint}) async {
    final pdf = pw.Document();

    final ByteData imageData1 = await rootBundle.load('assets/images/ailogo.png');
    final Uint8List posLogoBytes = imageData1.buffer.asUint8List();

    final studentInfo = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [




        pw.Text("Student Information", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text("Name: ${widget.student.name}", style: const pw.TextStyle(fontSize: 12)),
        pw.Text("Class: ${widget.student.className}", style: const pw.TextStyle(fontSize: 12)),
        pw.Text("Roll No: ${widget.student.rollNo}", style: const pw.TextStyle(fontSize: 12)),
        pw.Text("Section: ${widget.student.section}", style: const pw.TextStyle(fontSize: 12)),
        pw.Text("Course: ${widget.student.courseList}", style: const pw.TextStyle(fontSize: 12)),
        pw.Text("Parent Name: ${widget.student.parentName}", style: const pw.TextStyle(fontSize: 12)),
        pw.Text("Parent Contact: ${widget.student.parentContact}", style: const pw.TextStyle(fontSize: 12)),
        pw.Divider(),


      ],
    );

    final singleFeeInfo = feeToPrint != null
        ? pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'Current Fee Slip'),
        pw.Table.fromTextArray(
          headers: ['Month', 'Amount', 'Status', 'Paid Date'],
          data: [
            [
              feeToPrint['date'] ?? '',
              feeToPrint['amount'] ?? '',
              feeToPrint['status'] ?? '',
              feeToPrint['paidDate'] ?? '',
            ]
          ],
          border: pw.TableBorder.all(),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 10),
        ),
      ],
    )
        : pw.Container();


    final historyTable = _showHistory
        ? pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'Complete Fee History'),
        pw.Table.fromTextArray(
          headers: ['Month', 'Amount', 'Status', 'Paid Date'],
          data: (widget.student.feeHistory ?? []).map((fee) => [
            fee['date'],
            fee['amount'],
            fee['status'],
            fee['paidDate']
          ]).toList(),
          border: pw.TableBorder.all(),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 10),
        ),
      ],
    )
        : pw.Container();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 🔼 Logo on top
              pw.Center(
                child: pw.Image(
                  pw.MemoryImage(posLogoBytes),
                  width: 100,
                  height: 100,
                  fit: pw.BoxFit.contain,
                ),
              ),
              pw.SizedBox(height: 8),

              // 🔽 Brand Title under the logo
              pw.Center(
                child: pw.Text(
                  "AiLab Solutions",
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 16),


              studentInfo,
              _showHistory ? historyTable : singleFeeInfo,

              pw.Divider(),
              pw.Text('Contact Information',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Text(' Address: 123 Main Street, City Name',
                  style: const pw.TextStyle(fontSize: 14)),
              pw.Text(' Phone: +92 3058431046     Email: ailabsolutions046@gmail.com',
                  style: const pw.TextStyle(fontSize: 14)),
              pw.Text(' Website: htttps:// launchcode.shop',
                  style:  pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
              pw.Text('Registered with SECP',
                  style:  pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
              pw.Text(' CUI No. 0290410',
                  style:  pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
              pw.SizedBox(height: 6),
              pw.Text('Thank you for staying with us.',
                  style: const pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  void _printDocument(Map<String, dynamic>? feeToPrint) {
    if (feeToPrint == null && !_showHistory) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please save a fee entry first or toggle history view.")),
      );
      return;
    }
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => _createPdf(format, feeToPrint: feeToPrint),
    );
  }

  void _printThermal(Map<String, dynamic>? feeToPrint) {
    if (feeToPrint == null && !_showHistory) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please save a fee entry first or toggle history view.")),
      );
      return;
    }
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => _createPdf(
        const PdfPageFormat(58 * PdfPageFormat.mm, 80 * PdfPageFormat.mm),
        feeToPrint: feeToPrint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Fee Slip"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("👨‍🎓 Student Information", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Text("👤 Name: ${student.name}"),
                    Text("🏫 Class: ${student.className}"),
                    Text("🎯 Roll No: ${student.rollNo}"),
                    Text("🧩 Section: ${student.section}"),
                    Text("📚 Course: ${student.courseList}"),
                    Text("👪 Parent Name: ${student.parentName}"),
                    Text("📞 Parent Contact: ${student.parentContact}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              runSpacing: 12,
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: pickMonth,
                  icon: const Icon(Icons.date_range),
                  label: Text(selectedMonth == null
                      ? "Select Month"
                      : "Month: ${selectedMonth!.month}/${selectedMonth!.year}"),
                ),
                ElevatedButton.icon(
                  onPressed: pickPaidDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(paidDate == null
                      ? "Select Paid Date"
                      : "Paid on: ${paidDate!.day}/${paidDate!.month}/${paidDate!.year}"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Fee Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => addFeeEntry(student.id, student.feeHistory ?? []),
              icon: const Icon(Icons.save),
              label: const Text("Save Fee Entry"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text("Show Full Fee History on Slip"),
              value: _showHistory,
              onChanged: (bool value) => setState(() => _showHistory = value),
            ),
            const Divider(height: 30),
            ElevatedButton.icon(
              onPressed: () => _printDocument(_lastSavedFee),
              icon: const Icon(Icons.print),
              label: const Text("Print Slip (Web)"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _printThermal(_lastSavedFee),
              icon: const Icon(Icons.print_outlined),
              label: const Text("Print Slip (Thermal)"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }
}
