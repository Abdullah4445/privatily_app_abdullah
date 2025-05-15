import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:privatily_app/animations/serviceCards.dart';
import 'package:privatily_app/modules/stepstolaunch/stepstolaunch.dart';
import 'package:privatily_app/widgets/translationsController.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:seo/seo.dart'; // SEO package

import '../animations/animated_on_scrool.dart';
import '../animations/price.dart';
import '../modules/cart/cart_logic.dart';
import '../modules/cart/cart_view.dart';
import '../modules/chat_page/view.dart';
import '../modules/preview/privatily_preview_image.dart';
import '../modules/sections/FAQ_section.dart';
import '../modules/sections/FooterSection.dart';
import '../modules/sections/contact_us_seaction.dart';
import '../modules/sections/featuredProducts/featuredProducts.dart';
import '../modules/sections/home_stats_section.dart';
import '../modules/sections/how_much_time_section.dart';
import '../modules/sections/launch_any_whered_ection.dart';
import '../modules/sections/our_mission_section.dart';
import '../modules/sections/premium_bonuses_section.dart';
import '../modules/sections/testimonial_section.dart';
import '../modules/sections/transparent_pricing_seaction.dart';
import '../modules/sections/why_incorporate_us_section.dart';
import '../modules/sections/why_privatily_section.dart';
import 'homellogic.dart';
import 'myProgressIndicator.dart';

/// Home page with SEO enhancements
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final HomeLogic logic = Get.put(HomeLogic());
  final GlobalKey _faqKey = GlobalKey();
  final GlobalKey _testimonialKey = GlobalKey();
  final GlobalKey _featuredKey = GlobalKey();
  final GlobalKey _whyUsKey = GlobalKey();
  final GlobalKey _contactUsKey = GlobalKey();

  bool showChatBox = false;
  bool showLoginForm = false;
  bool showSignupForm = false;
  RxString selectedLang = 'en'.obs;

  void scrollToSection(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final offset = box.localToGlobal(Offset.zero).dy - kToolbarHeight;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget fiveStars(double screenWidth) {
    final iconSize =
        screenWidth < 600
            ? 18
            : screenWidth < 1024
            ? 22
            : 26;
    return GestureDetector(
      onTap: () => scrollToSection(_testimonialKey),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: List.generate(
                5,
                (_) => Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: double.parse(iconSize.toString()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'rated_stars'.tr,
              style: TextStyle(fontSize: iconSize * 0.6, fontWeight: FontWeight.bold),
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
        duration: const Duration(milliseconds: 500),
        transitionBuilder:
            (child, anim) => FadeTransition(
              opacity: anim,
              child: ScaleTransition(
                scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
            ),
        child:
            showChatBox
                ? Material(
                  key: const ValueKey('chatbox'),
                  borderRadius: BorderRadius.circular(20),
                  elevation: 8,
                  color: Colors.transparent,
                  child: Container(
                    width: 360,
                    height: 480,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 25)],
                    ),
                    child: Obx(
                      () =>
                          logic.showChatScreen.value
                              ? ChattingPage(
                                chatRoomId: logic.chatRoomIdForPopup.value,
                                receiverId: logic.receiverIdForPopup.value,
                                receiverName: logic.receiverNameForPopup.value,
                              )
                              : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget floatingMessageButton() => FloatingActionButton(
    backgroundColor: Colors.deepPurple,
    onPressed: () async {
      setState(() => showChatBox = !showChatBox);
      if (showChatBox) await logic.initGuestChat();
    },
    child: Icon(
      showChatBox ? Icons.close : Icons.chat_bubble_outline,
      color: Colors.white,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Seo.head(
      tags: [
        MetaTag(
          name: 'description',
          content:
              'LaunchCode: launch sooner and grow faster with our software marketplace.',
        ),
        LinkTag(rel: 'canonical', href: 'https://launchcode.shop/'),
      ],
      child: Builder(
        builder: (ctx) {
          final screenWidth = MediaQuery.of(context).size.width;
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Image.asset('assets/images/logo_white.png', height: 120),
                  backgroundColor: Colors.white,
                  actions: [
                    if (ResponsiveBreakpoints.of(context).largerThan(MOBILE))
                      TextButton(
                        onPressed: () => scrollToSection(_whyUsKey),
                        child: Text('Why Us?'.tr),
                      ),
                    TextButton(
                      onPressed: () => scrollToSection(_contactUsKey),
                      child: Text('Contact Us!'.tr),
                    ),
                    if (ResponsiveBreakpoints.of(context).largerThan(MOBILE))
                      TextButton(
                        onPressed: () => scrollToSection(_faqKey),
                        child: Text('FAQ'.tr),
                      ),
                    const Gap(10),
                    // Obx(() {
                    //   final count = Get.find<CartLogic>().itemCount;
                    //   return Badge(
                    //     label: Text(count.toString()),
                    //     isLabelVisible: count > 0,
                    //     child: IconButton(
                    //       icon: const Icon(Icons.shopping_cart),
                    //       onPressed: () => Get.toNamed(CartPage.routeName),
                    //     ),
                    //   );
                    // }),
                    // Language selector
                    Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      child: Obx(
                        () => DropdownButton<String>(
                          value: selectedLang.value,
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'fr', child: Text('Français')),
                            DropdownMenuItem(value: 'es', child: Text('Español')),
                            DropdownMenuItem(value: 'ar', child: Text('عربي')),
                          ],
                          onChanged: (val) {
                            selectedLang.value = val!;
                            Get.put(TranslationController()).changeLanguage(val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Hero with SEO text

                      // AnimatedOnScroll(
                      //   child: Seo.text(
                      //     text: 'ready_to_launch'.tr,
                      //     style: TextTagStyle.h2,
                      //     child: Text('ready_to_launch'.tr,
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontSize: screenWidth < 600
                      //                 ? 24
                      //                 : screenWidth < 1024
                      //                 ? 36
                      //                 : 46,
                      //             fontWeight: FontWeight.bold)),
                      //   ),
                      // ),
                      // const Gap(10),
                      // AnimatedOnScroll(
                      //   child: Seo.text(
                      //     text: 'leverageOur'.tr,
                      //     style: TextTagStyle.p,
                      //     child: Text('leverageOur'.tr,
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontSize: screenWidth < 600 ? 14 : 16,
                      //             color: Colors.black87)),
                      //   ),
                      // ),
                      const Gap(12),
                      // AnimatedOnScroll(
                      //   child: Seo.image(
                      //     src: 'assets/images/preview.png',
                      //     alt: 'LaunchCode app preview',
                      //     child: const PrivatilyPreviewImage(),
                      //   ),
                      // ),
                      AnimatedOnScroll(
                        child: Seo.text(
                          text: 'launch_sooner'.tr + ' ' + 'grow_faster'.tr,
                          style: TextTagStyle.h1,
                          child: _buildLaunchCodeHero(ctx),
                        ),
                      ),
                      const Gap(18),

                      const AnimatedOnScroll(child: HomeStatsSection()),

                      const Gap(18),
                      AnimatedOnScroll(
                        child: Seo.image(
                          src: 'assets/images/preview.png',
                          alt: 'LaunchCode app preview',
                          child: Column(
                            children: [
                              Seo.text(
                                text: 'other_services'.tr,
                                style: TextTagStyle.h1,
                                child: Column(
                                  children: [
                                    Text(
                                      'other_services'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: screenWidth < 600 ? 18 : 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    ServiceCards(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(18),
                      AnimatedOnScroll(child: WhyLaunchCodeSection(key: _whyUsKey)),
                      const AnimatedOnScroll(child: PremiumBonusSection()),
                      const AnimatedOnScroll(child: HowMuchTimeSection()),
                      const AnimatedOnScroll(child: WhyLaunchCodeSection2()),
                      const AnimatedOnScroll(child: TransparentPricingSection()),
                      AnimatedOnScroll(child: TestimonialSection(key: _testimonialKey)),
                      const AnimatedOnScroll(child: OurMissionSection()),
                      AnimatedOnScroll(child: FaqSection(key: _faqKey)),
                      const AnimatedOnScroll(child: LaunchAnywhereSection()),
                      AnimatedOnScroll(child: ContactUsSection(key: _contactUsKey)),
                      const AnimatedOnScroll(child: FooterSection()),
                    ],
                  ),
                ),
                floatingActionButton: floatingMessageButton(),
              ),
              chatPopup(),
            ],
          );
        },
      ),
    );
  }

  var greyBackSize = 800.0;

  Widget _buildLaunchCodeHero(BuildContext ctx) {
    final width = MediaQuery.of(ctx).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8F9FF), Color(0xFFEDEFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Lottie.asset(
                  'assets/lotties/rocket.json', // 🔥 change to your lottie
                  repeat: true,
                  animate: true,
                ),
              ),
              Text(
                'launch_sooner'.tr,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.trending_up, color: Colors.green, size: 28),
              Text(
                'grow_faster'.tr,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Gap(6),

          AnimatedOnScroll(
            child: Seo.image(
              src: 'assets/images/preview.png',
              alt: 'LaunchCode app preview',
              child: const LaunchSteps(),
            ),
          ),

          // const Gap(16),
          Container(
            height:
                !ResponsiveBreakpoints.of(context).isMobile
                    ? 750
                    : 660, // Adjusted height to fit everything comfortably
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  key: _featuredKey,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: const FeaturedProductsSection(),
                ),
                ResponsiveBreakpoints.of(context).isMobile?Container():SizedBox(
                  height: 500,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 600,
                        width: greyBackSize,
                        child: Lottie.asset('assets/lotties/myGreyBack.json'),
                      ),
                      SizedBox(
                        height: 600,
                        width: greyBackSize,
                        child: Lottie.asset('assets/lotties/myGreyBack.json'),
                      ),
                      SizedBox(
                        height: 600,
                        width: greyBackSize,
                        child: Lottie.asset('assets/lotties/myGreyBack.json'),
                      ),
                      SizedBox(
                        height: 600,
                        width: greyBackSize,
                        child: Lottie.asset('assets/lotties/myGreyBack.json'),
                      ),
                    ],
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: 190,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        // padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: [
                          // Wrap in a SizedBox to match the full width if content is small
                          ConstrainedBox(
                            constraints: BoxConstraints(minWidth: constraints.maxWidth),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                PlanCard(
                                  text: "BASIC PLAN",
                                  price: 150,
                                  supportDays: "Mon-Fri",
                                  deliveryTime: "15 Days",
                                ),
                                SizedBox(width: 2),
                                PlanCard(
                                  text: "ADVANCED PLAN",
                                  price: 350,
                                  supportDays: "Mon-Sun",
                                  deliveryTime: "7 Days",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // 🟢 Lottie animation at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
