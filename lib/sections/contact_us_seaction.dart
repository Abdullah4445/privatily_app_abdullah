import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUsSection extends StatefulWidget {
  const ContactUsSection({super.key});

  @override
  State<ContactUsSection> createState() => _ContactUsSectionState();
}

class _ContactUsSectionState extends State<ContactUsSection> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final ideaC = TextEditingController();
  final notesC = TextEditingController();

  Future<void> sendEmail() async {
    const serviceId = 'service_it33gkb';
    const templateId = 'template_m13d8vd';
    const userId = 'F-HN-DXZHU9uQ66dD';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'from_name': nameC.text,
          'from_email': emailC.text,
          'business_idea': ideaC.text,
          'additional_notes': notesC.text,
        },
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Email sent successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      nameC.clear();
      emailC.clear();
      ideaC.clear();
      notesC.clear();
    } else {
      Get.snackbar(
        'Error',
        'Failed to send email',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Stack(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00C853), Color(0xFF1B5E20)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'contact_heading'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'contact_subheading'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(30),
                        child: Flex(
                          direction: isMobile ? Axis.vertical : Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: isMobile ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'contact_form_title'.tr,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildInput(
                                    controller: nameC,
                                    hint: 'contact_name'.tr,
                                  ),
                                  _buildInput(
                                    controller: emailC,
                                    hint: 'contact_email'.tr,
                                  ),
                                  _buildInput(
                                    controller: ideaC,
                                    hint: 'contact_idea'.tr,
                                  ),
                                  _buildInput(
                                    controller: notesC,
                                    hint: 'contact_notes'.tr,
                                    maxLines: 4,
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF00C853,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: sendEmail,
                                      child: Text('contact_button'.tr),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isMobile) const SizedBox(width: 40),
                            if (!isMobile)
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Image.asset(
                                      'assets/images/contact_team.png',
                                      fit: BoxFit.contain,
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Image.asset(
                                        'assets/images/banner_1.png',
                                        width: 260,
                                      ),
                                    ),
                                    Positioned(
                                      top: 80,
                                      left: 10,
                                      child: Image.asset(
                                        'assets/images/banner_2.png',
                                        width: 240,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF3F6FD),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
