import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../animations/animated_on_scrool.dart';
import '../chat_page/view.dart';
import '../home_page/logic.dart';
import '../preview/privatily_preview_image.dart';
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
import 'homellogic.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final HomeLogic logic = Get.put(HomeLogic()); // Logic to manage chat and guest user
  bool showChatBox = false;

  // Name for guest user

    // Create guest user in Firestore


  // Function to show chat popup
  Widget chatPopup() {
    return Positioned(
      bottom: 100,
      right: 24,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // ✅ Combined Fade + Scale + Slide
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
          );
        },
        child: showChatBox
            ? Container(
          key: const ValueKey('chatbox'),
          width: 360,
          height: 480,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 25,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                // 🔷 Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4B2EDF), Color(0xFF7B5CFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "💬 Chat with us",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => showChatBox = false),
                        child: const Icon(Icons.close, color: Colors.white),
                      )
                    ],
                  ),
                ),

                // 🔄 Chat Content
                Expanded(
                  child: Container(
                    color: const Color(0xFFF7F7FB),
                    child: Obx(() => logic.showChatScreen.value
                        ? ChattingPage(
                      chatRoomId: logic.chatRoomIdForPopup.value,
                      receiverId: logic.receiverIdForPopup.value,
                      receiverName: logic.receiverNameForPopup.value,
                    )
                        : const Center(child: CircularProgressIndicator())),
                  ),
                ),
              ],
            ),
          ),
        )
            : const SizedBox.shrink(),
      ),
    );
  }



  // Initial buttons for starting chat as guest


  // Floating action button to toggle chat
  Widget floatingMessageButton() {
    return Positioned(
      bottom: 24,
      right: 24,
      child: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          setState(() => showChatBox = !showChatBox);
          if (showChatBox) {
            await logic.initGuestChat();
          }
        },
        child: Icon(
          showChatBox ? Icons.close : Icons.chat_bubble_outline,
          color: Colors.white,
        ),
      ),
    );
  }


  // Scroll to testimonials
  void scrollToTestimonials() {
    final RenderBox renderBox = _testimonialKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero, ancestor: null).dy;
    _scrollController.animateTo(
      position + _scrollController.offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  // Five-star rating section
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

  // Widget for displaying testimonial section
  final GlobalKey _testimonialKey = GlobalKey();

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
