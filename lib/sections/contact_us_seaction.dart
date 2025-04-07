import 'package:flutter/material.dart';

class ContactUsSection extends StatelessWidget {
  const ContactUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Stack(
          children: [
            // 🔵 Gradient top background
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3E29F0), Color(0xFF4E38F8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // 🧾 Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Reach Out, We're Here to Help!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Complete the form, and our team will promptly respond to your inquiry within our working hours!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 📦 Form + Image Box
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
                            // ✉️ Form Side
                            Expanded(
                              flex: isMobile ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Send us a message',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildInput('Name'),
                                  _buildInput('Email'),
                                  _buildInput('Subject'),
                                  _buildInput('Message', maxLines: 4),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: const Text('Send message'),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (!isMobile) const SizedBox(width: 40),

                            // 👨‍💻 Image + Banners (with Stack)
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
                                        'assets/images/banner_1.png', // replace with your image name
                                        width: 260,
                                      ),
                                    ),
                                    Positioned(
                                      top: 80,
                                      left: 10,
                                      child: Image.asset(
                                        'assets/images/banner_2.png', // replace with your image name
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

  Widget _buildInput(String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF3F6FD),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
