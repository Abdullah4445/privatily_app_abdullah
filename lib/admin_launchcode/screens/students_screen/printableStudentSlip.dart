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







  // WEB PRINT KE LIYE PDF BANANE KA FUNCTION
  Future<Uint8List> _createWebPdf(PdfPageFormat format, {Map<String, dynamic>? feeToPrint}) async {
    final pdf = pw.Document();

    final ByteData imageData1 = await rootBundle.load('assets/images/ailogo.png');
    final Uint8List posLogoBytes = imageData1.buffer.asUint8List();

    // Student Info aur Fee Tables ka code bilkul waisa hi rahega
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
          data: (widget.student.feeHistory ?? [])
              .map((fee) => [fee['date'], fee['amount'], fee['status'], fee['paidDate']])
              .toList(),
          border: pw.TableBorder.all(),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 10),
        ),
      ],
    )
        : pw.Container();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return pw.Column(children: [
              pw.Center(
                child: pw.Image(
                  pw.MemoryImage(posLogoBytes),
                  width: 100,
                  height: 100,
                  fit: pw.BoxFit.contain,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  "AiLab Solutions",
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 16),
            ]);
          }
          return pw.Container();
        },
        footer: (pw.Context context) {
          return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Divider(),
            pw.Text('Contact Information', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Text(' Address: 123 Main Street, City Name', style: const pw.TextStyle(fontSize: 14)),
            pw.Text(' Phone: +92 3058431046     Email: ailabsolutions046@gmail.com', style: const pw.TextStyle(fontSize: 14)),
            pw.Text(' Website: https://launchcode.shop', style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
            pw.Text('Registered with SECP', style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
            pw.Text(' CUI No. 0290410', style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
            pw.SizedBox(height: 6),
            pw.Text('Thank you for staying with us.', style: const pw.TextStyle(fontSize: 18)),
          ]);
        },
        build: (pw.Context context) {
          return [
            studentInfo,
            _showHistory ? historyTable : singleFeeInfo,
          ];
        },
      ),
    );

    return pdf.save();
  }


// THERMAL PRINT KE LIYE BEHTAR PDF BANANE KA FUNCTION
  Future<Uint8List> _createThermalPdf({Map<String, dynamic>? feeToPrint}) async {
    // Page format for thermal (58mm roll)
    const PdfPageFormat format =
    PdfPageFormat(80 * PdfPageFormat.mm, double.infinity, marginAll: 4 * PdfPageFormat.mm);
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    final ByteData imageData1 = await rootBundle.load('assets/images/ailogo.png');
    final Uint8List posLogoBytes = imageData1.buffer.asUint8List();

    // Font styles
    const smallStyle = pw.TextStyle(fontSize: 9);
    const normalStyle = pw.TextStyle(fontSize: 10);
    final boldStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10);
    final tableHeaderStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.5);
    final tableCellStyle = const pw.TextStyle(fontSize: 8);

    // ✅ Helper: Table Builder (adjusted widths for full words)
    pw.Widget buildTable(List<Map<String, dynamic>> rows) {
      return pw.Table(
        border: pw.TableBorder.all(width: 0.6),
        columnWidths: {
          0: const pw.FlexColumnWidth(2.2), // Month (slightly reduced)
          1: const pw.FlexColumnWidth(2.5), // Amount (increased)
          2: const pw.FlexColumnWidth(2.5), // Status (increased)
          3: const pw.FlexColumnWidth(3.0), // Paid Date (slightly reduced)
        },
        children: [
          // Header row
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text('Month', style: tableHeaderStyle, textAlign: pw.TextAlign.center),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text('Amount', style: tableHeaderStyle, textAlign: pw.TextAlign.center),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text('Status', style: tableHeaderStyle, textAlign: pw.TextAlign.center),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text('Paid Date', style: tableHeaderStyle, textAlign: pw.TextAlign.center),
              ),
            ],
          ),

          // Data rows
          ...rows.map((fee) {
            return pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(2),
                  child: pw.Text("${fee['date'] ?? ''}",
                      style: tableCellStyle, textAlign: pw.TextAlign.center, softWrap: true, maxLines: 2),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(2),
                  child: pw.Text("${fee['amount'] ?? ''}",
                      style: tableCellStyle, textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(2),
                  child: pw.Text("${fee['status'] ?? ''}",
                      style: tableCellStyle, textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(2),
                  child: pw.Text("${fee['paidDate'] ?? ''}",
                      style: tableCellStyle, textAlign: pw.TextAlign.center, softWrap: true, maxLines: 2),
                ),
              ],
            );
          }).toList(),
        ],
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          // Select which table to show
          final feeTable = _showHistory
              ? buildTable((widget.student.feeHistory ?? []).cast<Map<String, dynamic>>())
              : feeToPrint != null
              ? buildTable([feeToPrint])
              : pw.Container();

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo & Title
              pw.Center(child: pw.Image(pw.MemoryImage(posLogoBytes), width: 70, height: 70)),
              pw.SizedBox(height: 3 * PdfPageFormat.mm),
              pw.Center(
                child: pw.Text("AiLab Solutions",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              ),
              pw.SizedBox(height: 5 * PdfPageFormat.mm),

              // Student Information
              pw.Text("Student Information", style: boldStyle),
              pw.Divider(height: 1, thickness: 0.5),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text("Name: ${widget.student.name}", style: normalStyle),
              pw.Text("Class: ${widget.student.className}", style: normalStyle),
              pw.Text("Roll No: ${widget.student.rollNo}", style: normalStyle),
              pw.Text("Section: ${widget.student.section}", style: normalStyle),
              pw.Text("Course: ${widget.student.courseList}", style: normalStyle, softWrap: true, maxLines: 2),
              pw.Text("Parent: ${widget.student.parentName}", style: normalStyle),
              pw.Text("Contact: ${widget.student.parentContact}", style: normalStyle),
              pw.SizedBox(height: 5 * PdfPageFormat.mm),

              // Fee Details
              pw.Text(_showHistory ? 'Complete Fee History' : 'Current Fee Slip', style: boldStyle),
              pw.Divider(height: 1, thickness: 0.5),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              feeTable,
              pw.SizedBox(height: 5 * PdfPageFormat.mm),

              // Footer
              pw.Text("Contact Information", style: boldStyle),
              pw.Divider(height: 1, thickness: 0.5),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text('Address: 123 Main Street, City Name', style: smallStyle),
              pw.Text('Phone: +92 3058431046', style: smallStyle),
              pw.Text('Email: ailabsolutions046@gmail.com', style: smallStyle),
              pw.Text('Website: https://launchcode.shop', style: smallStyle),
              pw.Text('Registered with SECP', style: smallStyle),
              pw.Text('CUI No. 0290410', style: smallStyle),
              pw.SizedBox(height: 4 * PdfPageFormat.mm),

              // Thank you
              pw.Center(child: pw.Text('Thank you for staying with us.', style: normalStyle)),
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
      onLayout: (PdfPageFormat format) async => _createWebPdf(format, feeToPrint: feeToPrint),
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
      // Yahan ab hum direct thermal PDF function call kar rahe hain
      onLayout: (PdfPageFormat format) async => _createThermalPdf(feeToPrint: feeToPrint),
    );
  }

// ... Aapka build function waisa hi rahega

// Baaqi sara code waisa hi rakhein

// Baaqi sara code waisa hi rakhein

  // void _printDocument(Map<String, dynamic>? feeToPrint) {
  //   if (feeToPrint == null && !_showHistory) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please save a fee entry first or toggle history view.")),
  //     );
  //     return;
  //   }
  //   Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => _createPdf(format, feeToPrint: feeToPrint),
  //   );
  // }
  //
  // void _printThermal(Map<String, dynamic>? feeToPrint) {
  //   if (feeToPrint == null && !_showHistory) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please save a fee entry first or toggle history view.")),
  //     );
  //     return;
  //   }
  //   Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => _createPdf(
  //       const PdfPageFormat(58 * PdfPageFormat.mm, 80 * PdfPageFormat.mm),
  //       feeToPrint: feeToPrint,
  //     ),
  //   );
  // }

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
