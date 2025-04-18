import 'dart:io';

import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:privatily_app/chatToAdmin/chatpops.dart';
import 'package:privatily_app/sections/premium_bonuses_section.dart';
import '../login_screen/logic.dart';
import '../mytextfield/custom_field.dart';
import '../sections/FAQ_section.dart';
import '../sections/FooterSection.dart';
import '../sections/contact_us_seaction.dart';
import '../sections/featuredProducts/featuredProducts.dart';
import '../sections/home_stats_section.dart';
import '../sections/how_much_time_section.dart';
import '../sections/launch_any_whered_ection.dart';
import '../sections/our_mission_section.dart';
import '../sections/testimonial_section.dart';
import '../sections/transparent_pricing_seaction.dart';
import '../sections/why_incorporate_us_section.dart';
import '../sections/why_privatily_section.dart';
import '../animations/animated_on_scrool.dart';
import '../preview/privatily_preview_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final Login_pageLogic logic = Get.put(Login_pageLogic());

  final GlobalKey _testimonialKey = GlobalKey();
  bool showChatBox = false;
  bool showLoginForm = false;
  bool showSignupForm = false;
  RxString selectedLang = 'en'.obs;

  void scrollToTestimonials() {
    final RenderBox renderBox =
        _testimonialKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero, ancestor: null).dy;
    _scrollController.animateTo(
      position + _scrollController.offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Widget fiveStars(double screenWidth) {
    double iconSize =
        screenWidth < 600
            ? 18
            : screenWidth < 1024
            ? 22
            : 26;
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
              'rated_stars'.tr,
              style: TextStyle(
                fontSize: iconSize * 0.6,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        child: showChatBox ? ToAdminChat() : const SizedBox.shrink(),
      ),
    );
  }

  Widget buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPopupHeader("login_title".tr),
        const SizedBox(height: 16),
        CustomInputField(controller: logic.emailC, hintText: 'email'.tr),
        const SizedBox(height: 12),
        CustomInputField(
          controller: logic.passC,
          hintText: 'password'.tr,
          isPassword: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => logic.signIn(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text(
            "login_btn".tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget buildSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPopupHeader("signup_title".tr),
        const SizedBox(height: 16),
        CustomInputField(controller: logic.NameC, hintText: 'user_name'.tr),
        const SizedBox(height: 12),
        CustomInputField(controller: logic.emailC, hintText: 'email'.tr),
        const SizedBox(height: 12),
        CustomInputField(
          controller: logic.passC,
          hintText: 'password'.tr,
          isPassword: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => logic.createUser(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text(
            "signup_btn".tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget buildPopupHeader(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed:
              () => setState(() {
                showChatBox = false;
                showLoginForm = false;
                showSignupForm = false;
              }),
        ),
      ],
    );
  }

  Widget buildChatButtons() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed:
                () => setState(() {
                  showLoginForm = true;
                  showSignupForm = false;
                }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: Text(
              "login_btn".tr,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                () => setState(() {
                  showSignupForm = true;
                  showLoginForm = false;
                }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: Text(
              "signup_btn".tr,
              style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget floatingMessageButton() {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      onPressed: () => setState(() => showChatBox = !showChatBox),
      child: Icon(
        showChatBox ? Icons.close : Icons.chat_bubble_outline,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLaunchCodeHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 30),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8F9FF), Color(0xFFEDEFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              runSpacing: 5,
              children: [
                const Icon(
                  Icons.rocket_launch,
                  color: Colors.deepPurple,
                  size: 30,
                ),
                Text(
                  "launch_sooner".tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.trending_up, color: Colors.green, size: 30),
                Text(
                  "grow_faster".tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedLang.value,
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'fr', child: Text('Français')),
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'ar', child: Text('عربي')),
                  ],
                  onChanged: (value) {
                    selectedLang.value = value!;
                    if (value == 'en') {
                      Get.updateLocale(const Locale('en', 'US'));
                    } else if (value == 'fr') {
                      Get.updateLocale(const Locale('fr', 'FR'));
                    } else if (value == 'es') {
                      Get.updateLocale(const Locale('es', 'ES'));
                    } else if (value == 'ar') {
                      Get.updateLocale(const Locale('ar', 'AR'));
                    }
                  },
                ),
              ],
            ),
            const Gap(10),
            Text(
              'discover_software'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const Gap(15),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.explore, color: Colors.white),
                  label: Text(
                    "explore_products".tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.code),
                  label: Text("browse_categories".tr),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    side: const BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
            const Gap(10),
            const FeaturedProductsSection(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final desiredExpandedHeight = 500.0; // Your desired expanded height

    // Calculate a stretchMaxHeight that is larger than the fraction of screenHeight
    // represented by desiredExpandedHeight, and less than 0.95.
    final expandedFraction = desiredExpandedHeight / screenHeight;
    final stretchFraction =
        (expandedFraction > 0.8) ? 0.9 : expandedFraction + 0.15;
    final safeStretchFraction = stretchFraction < 0.95 ? stretchFraction : 0.9;
    final screenWidth = MediaQuery.of(context).size.width;

    var myHeightIs = MediaQuery.of(context).size.height * 0.15;
    var myHeightIs2 = MediaQuery.of(context).size.height * 0.05;
    print("myHeight is: $myHeightIs");
    print("myHeight2 is: $myHeightIs2");
    return Stack(
      children: [
        DraggableHome(
          // stretchMaxHeight: 500,
          // headerExpandedHeight: 400,
          // stretch: true, // Enable stretching beyond headerExpandedHeight (optional)
          // stretch: true,
          stretchMaxHeight: 0.9,
          // Example: 80% of screen height
          // headerExpandedHeight:   0.8,
          headerExpandedHeight: kIsWeb ? 0.7 : 0.8,

          title: Row(
            children: [
              Image.asset("assets/images/logo_white.png", height: 120),
            ],
          ),
          headerWidget: _buildLaunchCodeHero(context),
          body: [_myBody(context, screenWidth)],
          floatingActionButton: floatingMessageButton(),
        ),
        chatPopup(),
      ],
    );
  }

  Widget _myBody(context, screenWidth) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(60),
          Text(
            'ready_to_launch'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:
                  screenWidth < 600
                      ? 28
                      : screenWidth < 1024
                      ? 40
                      : 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          Text(
            'leverage_scripts'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth < 600 ? 14 : 16,
              color: Colors.black87,
            ),
          ),

          const Gap(10),
          fiveStars(screenWidth),
          const Gap(30),
          const AnimatedOnScroll(child: PrivatilyPreviewImage()),
          const AnimatedOnScroll(child: HomeStatsSection()),
          const AnimatedOnScroll(child: WhyLaunchCodeSection()),
          const AnimatedOnScroll(child: PremiumBonusSection()),
          const AnimatedOnScroll(child: HowMuchTimeSection()),
          const AnimatedOnScroll(child: WhyLaunchCodeSection2()),
          const AnimatedOnScroll(child: TransparentPricingSection()),
          AnimatedOnScroll(
            child: Container(
              key: _testimonialKey,
              child: const TestimonialSection(),
            ),
          ),
          const AnimatedOnScroll(child: OurMissionSection()),
          const AnimatedOnScroll(child: FaqSection()),
          const AnimatedOnScroll(child: LaunchAnywhereSection()),
          const AnimatedOnScroll(child: ContactUsSection()),
          const AnimatedOnScroll(child: FooterSection()),
        ],
      ),
    );
  }
}
