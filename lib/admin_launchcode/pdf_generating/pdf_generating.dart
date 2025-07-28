// lib/pdf_generating/pdf_generating.dart

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../models/students.dart'; // Apna sahi path dein

class PdfGenerator {
  static Future<Uint8List> generateStudentSlip(Students student, {bool showHistory = true}) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.openSansRegular();
    final boldFont = await PdfGoogleFonts.openSansBold();

    final latestFeeStatus = student.feeHistory?.isNotEmpty == true
        ? student.feeHistory!.last['status']
        : 'Unknown';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    "Student Fee Slip",
                    style: pw.TextStyle(font: boldFont, fontSize: 22, decoration: pw.TextDecoration.underline),
                  ),
                ),
                pw.SizedBox(height: 30),
                _buildDetailRow("Student Name:", student.name, boldFont, font),
                _buildDetailRow("Roll No:", student.rollNo ?? 'N/A', boldFont, font),
                _buildDetailRow("Class:", student.className ?? 'N/A', boldFont, font),
                _buildDetailRow("Generated On:", DateFormat('dd-MMM-yyyy').format(DateTime.now()), boldFont, font),
                pw.SizedBox(height: 20),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 10),

                if (showHistory) ...[
                  pw.Text(
                    "Fee History:",
                    style: pw.TextStyle(font: boldFont, fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                  _buildFeeHistoryTable(student, font, boldFont), // Updated table
                ],

                pw.Spacer(),
                pw.Center(
                  child: pw.Text(
                    "Overall Status: $latestFeeStatus",
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 16,
                      color: latestFeeStatus == 'Paid' ? PdfColors.green700 : PdfColors.red700,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Center(child: pw.Text("--- Thank You ---", style: pw.TextStyle(font: font)))
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  static pw.Widget _buildDetailRow(String title, String value, pw.Font bold, pw.Font normal) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: pw.TextStyle(font: bold, fontSize: 14)),
          pw.Text(value, style: pw.TextStyle(font: normal, fontSize: 14)),
        ],
      ),
    );
  }

  // === YEH FUNCTION AAPKE NAYE DATA KE MUTAABIQ UPDATE KIYA GAYA HAI ===
  static pw.Widget _buildFeeHistoryTable(Students student, pw.Font font, pw.Font boldFont) {
    if (student.feeHistory == null || student.feeHistory!.isEmpty) {
      return pw.Center(child: pw.Text("No fee history available.", style: pw.TextStyle(font: font, fontSize: 14)));
    }

    // Naye headers
    final headers = ['Fee Month', 'Paid Date', 'Amount', 'Status'];

    return pw.Table.fromTextArray(
      headers: headers,
      headerStyle: pw.TextStyle(font: boldFont, fontSize: 11),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellStyle: pw.TextStyle(font: font, fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
      },
      data: student.feeHistory!.map((fee) {
        // Data ko process kar ke list of strings banayein
        final feeMonth = fee['feeMonth']?.toString() ?? 'N/A';
        final amount = fee['amount']?.toStringAsFixed(2) ?? 'N/A';
        final status = fee['status']?.toString() ?? 'N/A';

        // Paid Date ko format karein
        String paidDateStr = 'N/A';
        if (fee['paidDate'] is Timestamp) {
          paidDateStr = DateFormat('dd-MMM-yy').format((fee['paidDate'] as Timestamp).toDate());
        }

        return [feeMonth, paidDateStr, amount, status];
      }).toList(),
    );
  }
}