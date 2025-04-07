import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:privatily_app/preview/privatily_preview_image.dart';
import '../sections/FAQ_section.dart';
import '../sections/FooterSection.dart';
import '../sections/contact_us_seaction.dart';
import '../sections/home_stats_section.dart';
import '../sections/how_much_time_section.dart';
import '../sections/launch_any_whered_ection.dart';
import '../sections/our_mission_section.dart';
import '../sections/testimonial_section.dart';
import '../sections/transparent_pricing_seaction.dart';
import '../sections/why_incorporate_us_section.dart';
import '../sections/why_privatily_section.dart';
import '../animations/animated_on_scrool.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _testimonialKey = GlobalKey();
  bool showChatBox = false;

  void scrollToTestimonials() {
    final RenderBox renderBox = _testimonialKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero, ancestor: null).dy;
    _scrollController.animateTo(
      position + _scrollController.offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Widget fiveStars(double screenWidth) {
    double iconSize = screenWidth < 600 ? 18 : screenWidth < 1024 ? 22 : 26;
    return GestureDetector(
      onTap: scrollToTestimonials,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(Icons.star, color: Colors.orange, size: iconSize);
              }),
            ),
            const SizedBox(width: 12),
            Text(
              'Rated 4.2+ stars by entrepreneurs worldwide',
              style: TextStyle(fontSize: iconSize * 0.6, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget chatPopup() {
    return Positioned(
      bottom: 100,
      right: 24,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: showChatBox
            ? Container(
          key: const ValueKey('chatbox'),
          width: 360,
          height: 480,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 25)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade100,
                    child: const Icon(Icons.auto_awesome, color: Colors.deepPurple),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Privatily\nAI Assistant",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => showChatBox = false),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              chatBubble(
                icon: Icons.auto_awesome,
                time: "5:53 AM",
                text: "Hi, We're online 24/7",
              ),
              chatBubble(
                icon: Icons.auto_awesome,
                time: "5:54 AM",
                text: "Please enter your email",
                inputHint: "john.doe@example.com",
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Fill in your details",
                        filled: true,
                        fillColor: const Color(0xFFF3F6FD),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.deepPurple,
                    onPressed: () {},
                    child: const Icon(Icons.send, size: 18),
                  )
                ],
              )
            ],
          ),
        )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget chatBubble({required IconData icon, required String time, required String text, String? inputHint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: Colors.deepPurple.shade50, child: Icon(icon, color: Colors.deepPurple)),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: const TextStyle(fontSize: 14)),
                  if (inputHint != null) ...[
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: inputHint,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(time, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget floatingMessageButton() {
    return Positioned(
      bottom: 24,
      right: 24,
      child: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => setState(() => showChatBox = !showChatBox),
        child: Icon(showChatBox ? Icons.close : Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(60),
                Text(
                  'Form your company\nfrom anywhere',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth < 600 ? 28 : screenWidth < 1024 ? 40 : 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(20),
                Text(
                  'Join the thousands of entrepreneurs using our platform to incorporate their\ncompanies and unlock premium payment & banking options.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenWidth < 600 ? 14 : 16, color: Colors.black87),
                ),
                const Gap(10),
                fiveStars(screenWidth),
                const Gap(30),
                AnimatedOnScroll(child: const PrivatilyPreviewImage()),
                AnimatedOnScroll(child: const HomeStatsSection()),
                AnimatedOnScroll(child: const WhyPrivatilySection()),
                AnimatedOnScroll(child: const HowMuchTimeSection()),
                AnimatedOnScroll(child: const WhyIncorporateUsSection()),
                AnimatedOnScroll(child: const TransparentPricingSection()),
                AnimatedOnScroll(
                  child: Container(
                    key: _testimonialKey,
                    child: const TestimonialSection(),
                  ),
                ),
                AnimatedOnScroll(child: const OurMissionSection()),
                AnimatedOnScroll(child: const FaqSection()),
                AnimatedOnScroll(child: const LaunchAnywhereSection()),
                AnimatedOnScroll(child: const ContactUsSection()),
                AnimatedOnScroll(child: const FooterSection()),
              ],
            ),
          ),
          chatPopup(),
          floatingMessageButton(),
        ],
      ),
    );
  }
}
