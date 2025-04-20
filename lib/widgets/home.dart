import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:privatily_app/widgets/translationsController.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../animations/animated_on_scrool.dart';
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final HomeLogic logic = Get.put(
    HomeLogic(),
  ); // Logic to manage chat and guest user
  // final Login_pageLogic logic = Get.put(Login_pageLogic());

  //keys
  final ScrollController _faqKey = ScrollController();

  final GlobalKey _testimonialKey = GlobalKey();
  bool showChatBox = false;
  bool showLoginForm = false;
  bool showSignupForm = false;
  RxString selectedLang = 'en'.obs;

  // Name for guest user
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

  // Create guest user in Firestore
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

  // Function to show chat popup
  Widget chatPopup() {
    return Positioned(
      bottom: 100,
      right: 24,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
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
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 25),
              ],
            ),
            child: Obx(() => logic.showChatScreen.value
                ? ChattingPage(
              chatRoomId: logic.chatRoomIdForPopup.value,
              receiverId: logic.receiverIdForPopup.value,
              receiverName: logic.receiverNameForPopup.value,
            )
                : const Center(child: CircularProgressIndicator())),
          ),
        )
            : const SizedBox.shrink(),
      ),
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
    );
  }


  Widget _buildLaunchCodeHero(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 30),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8F9FF), Color(0xFFEDEFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
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
                ],
              ),
              const Gap(10),
              Text(
                'discover_software'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ],
          ),
          const Gap(6),
          const FeaturedProductsSection(),
          const Gap(5),
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
        ],
      ),
    );
  }

  final GlobalKey _sectionFiveKey = GlobalKey();
  final GlobalKey _sectionWhyUs = GlobalKey();
  final GlobalKey _sectionContactUs = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final desiredExpandedHeight = 500.0; // Your desired expanded height
    final currentLocale = Get.locale;
    print(currentLocale);
    // Calculate a stretchMaxHeight that is larger than the fraction of screenHeight
    // represented by desiredExpandedHeight, and less than 0.95.
    final expandedFraction = desiredExpandedHeight / screenHeight;
    final stretchFraction =
        (expandedFraction > 0.8) ? 0.9 : expandedFraction + 0.15;
    final safeStretchFraction = stretchFraction < 0.95 ? stretchFraction : 0.9;
    final screenWidth = MediaQuery.of(context).size.width;

    return Builder(
      builder: (BuildContext contextWithLocalization) {
        return Stack(
          children: [
            Scaffold(
              // stretchMaxHeight: 500,
              // headerExpandedHeight: 400,
              // stretch: true, // Enable stretching beyond headerExpandedHeight (optional)
              // stretch: true,
              // stretchMaxHeight: 0.9,
              // // Example: 80% of screen height
              // // headerExpandedHeight:   0.8,
              // headerExpandedHeight: kIsWeb ? 0.7 : 0.8,
              appBar: AppBar(
                title:
                    Image.asset("assets/images/logo_white.png", height: 120,),



                backgroundColor: Colors.transparent,
                actions: [
                  !ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? Container() :TextButton(
                    child: Text('Why Us?'.tr),
                    onPressed: () {
                      // Animate to the FAQ section
                      scrollToSection(_sectionWhyUs);
                    },
                  ),
                  TextButton(
                    child: Text('Contact Us!'.tr),
                    onPressed: () {
                      // Animate to the FAQ section
                      scrollToSection(_sectionContactUs);
                    },
                  ),
                  !ResponsiveBreakpoints.of(context).largerThan(MOBILE)?Container():TextButton(
                    child: Text('FAQ'.tr),
                    onPressed: () {
                      // Animate to the FAQ section
                      scrollToSection(_sectionFiveKey);
                    },
                  ),

                  Gap(10),
                  Obx(() { // Wrap with Obx to make it reactive
                    final cartController = Get.find<CartLogic>(); // Find controller inside Obx scope if needed
                    return Badge(
                      label: Text(cartController.itemCount.toString()), // Use controller's getter
                      isLabelVisible: cartController.itemCount > 0,
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Get.toNamed(CartPage.routeName); // GetX navigation
                        },
                      ),
                    );
                  }),
                  Container(
                    height: 30,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only( right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      )
                    ),
                    child: Row(
                      children: [
                        Container(
                          // margin: const EdgeInsets.only(right: 18.0),
                          // padding: const EdgeInsets.only(left: 12, right: 5.0),
                          // height: 50,
                          width: 80,

                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey[300]!, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: DecoratedBox(
                              // Using DecoratedBox to style the dropdown's background and potentially influence its container
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                // Set the dropdown background color here as well
                                borderRadius: BorderRadius.circular(
                                  12.0,
                                ), // Try adding rounded corners here
                              ),
                              child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                value: selectedLang.value,
                                underline: Container(),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'en',
                                    child: Text('English'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'fr',
                                    child: Text('Français'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'es',
                                    child: Text('Español'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ar',
                                    child: Text('عربي'),
                                  ),
                                ],
                                onChanged: (value) {
                                  selectedLang.value = value!;
                                  var myCont = Get.put(TranslationController());
                                  if (value == 'en') {
                                    myCont.changeLanguage('en');
                                  } else if (value == 'fr') {
                                    myCont.changeLanguage('fr');
                                  } else if (value == 'es') {
                                    myCont.changeLanguage('es');
                                  } else if (value == 'ar') {
                                    myCont.changeLanguage('ar');
                                  }
                                },
                                icon: Icon(Icons.arrow_drop_down_outlined),
                                // Add an icon to indicate it's a dropdown
                                isExpanded: true,
                                // Allows the dropdown to take the full width of its parent
                                style: const TextStyle(
                                  color: Colors.black,
                                ), // Style the text inside the button
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              // headerWidget: _buildLaunchCodeHero(context),
              body: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [_myBody(context, screenWidth)],
                ),
              ),
              floatingActionButton: floatingMessageButton(),
            ),
            chatPopup(),
          ],
        );
      },
    );
  }

  void scrollToSection(GlobalKey<State<StatefulWidget>> sectionKey) {
    final RenderBox? renderBox =
        sectionKey.currentContext?.findRenderObject() as RenderBox?;
    final offset =
        renderBox!.localToGlobal(Offset.zero).dy -
        (MediaQuery.of(context).padding.top +
            kToolbarHeight); // Adjust for AppBar height if present

    if (offset != null) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _myBody(context, screenWidth) {
    return SingleChildScrollView(
      // controller: _scrollController,
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedOnScroll(child: _buildLaunchCodeHero(context)),
          const Gap(10),

          AnimatedOnScroll(
            child: Text(
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
          ),
          const Gap(20),
          AnimatedOnScroll(
            child: Text(
              'leverageOur'.tr
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth < 600 ? 14 : 16,
                color: Colors.black87,
              ),
            ),
          ),

          const Gap(10),
          fiveStars(screenWidth),
          const Gap(30),
          const AnimatedOnScroll(child: PrivatilyPreviewImage()),
          const AnimatedOnScroll(child: HomeStatsSection()),
         AnimatedOnScroll(child: WhyLaunchCodeSection(key: _sectionWhyUs,)),
          AnimatedOnScroll(child: PremiumBonusSection()),
          const AnimatedOnScroll(child: HowMuchTimeSection()),
          const AnimatedOnScroll(child: WhyLaunchCodeSection2()),
          const AnimatedOnScroll(child: TransparentPricingSection()),
          AnimatedOnScroll(child: const TestimonialSection()),
          const AnimatedOnScroll(child: OurMissionSection()),
          AnimatedOnScroll(child: FaqSection(key: _sectionFiveKey)),
          const AnimatedOnScroll(child: LaunchAnywhereSection()),
            AnimatedOnScroll(child: ContactUsSection(key: _sectionContactUs,)),
          const AnimatedOnScroll(child: FooterSection()),
        ],
      ),
    );
  }
}
