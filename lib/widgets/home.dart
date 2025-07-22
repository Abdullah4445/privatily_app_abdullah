import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../modules/chat_page/chat/view/chatting_page.dart';
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
import '../student_lanuchcode/widgets/responsivefile.dart';
import 'homellogic.dart';
import 'myProgressIndicator.dart';

/// Home page with SEO enhancements
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final HomeLogic logic = Get.put(HomeLogic()); // Replace HomeLogic with your actual controller

  final GlobalKey _faqKey = GlobalKey();
  final GlobalKey _testimonialKey = GlobalKey();
  final GlobalKey _featuredKey = GlobalKey();
  final GlobalKey _whyUsKey = GlobalKey();
  final GlobalKey _contactUsKey = GlobalKey();

  RxBool showChatBox = false.obs;
  RxBool showLoginForm = false.obs;
  RxBool showSignupForm = false.obs;
  RxBool showRoleSelection = false.obs;
  bool isStudent = false;

  RxBool isLoggedIn = false.obs;
  String? selectedCourse;
  String? userRole;

  RxString selectedLang = 'en'.obs;
  List<String> courses = [];
  final HomeLogic courseLogic = HomeLogic(); // Replace HomeLogic with your actual logic class

  //Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _loadCourses();
    // Check initial login state
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      isLoggedIn.value = user != null;

      if (user != null) {
        // Fetch user role from Firestore after login
        await _fetchUserRole(user.uid);
      } else {
        userRole = null; // Reset the user role when logged out
      }
    });
  }

  Future<void> _loadCourses() async {
    courses = await courseLogic.getCoursesFromFirestore();
    setState(() {}); // Trigger a rebuild to update the dropdown
  }

  Future<void> _fetchUserRole(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection("Users").doc(userId).get();
      if (userDoc.exists) {
        userRole = userDoc.data()?['role'] as String?;
      } else {
        print("User document not found for ID: $userId");
        userRole = null;
      }
    } catch (e) {
      print("Error fetching user role: $e");
      userRole = null;
    }
  }

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

  // Widget fiveStars(double screenWidth) {
  //   final iconSize = screenWidth < 600 ? 18 : screenWidth < 1024 ? 22 : 26;
  //   return GestureDetector(
  //     onTap: () => scrollToSection(_testimonialKey),
  //     child: MouseRegion(
  //       cursor: SystemMouseCursors.click,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Row(
  //             children: List.generate(
  //               5,
  //                   (_) => Icon(
  //                 Icons.star,
  //                 color: Colors.orange,
  //                 size: double.parse(iconSize.toString()),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           Text(
  //             'rated_stars'.tr,
  //             style: TextStyle(
  //               fontSize: iconSize * 0.6,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// ✅ CHAT POPUP
  Widget chatPopup() {
    return Positioned(
      bottom: 100,
      right: 24,
      child: Obx(() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, anim) => FadeTransition(
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
        child: showChatBox.value
            ? Container(
          width: 360,
          child: Material(
            key: const ValueKey('chatbox'),
            borderRadius: BorderRadius.circular(20),
            elevation: 8,
            color: Colors.transparent,
            child: Container(
              width: 360,
              height: 480,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 25)
                ],
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://i.gifer.com/origin/0f/0f412581c9c78dec416072c7a42ef1b4.gif',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.white.withOpacity(0.7),
                    padding: const EdgeInsets.all(16),
                    child: Obx(() {
                      if (logic.isLoading.value) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (logic.showChatScreen.value) {
                        return ChattingPage(
                          chatRoomId: logic.chatRoomIdForPopup.value,
                          receiverId: logic.receiverIdForPopup.value,
                          receiverName: logic.receiverNameForPopup.value,
                        );
                      } else if (showRoleSelection.value) {
                        return _buildRoleSelection();
                      } else if (showLoginForm.value) {
                        return _buildLoginForm();
                      } else if (showSignupForm.value) {
                        return _buildSignupForm();
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showLoginForm.value = true;
                                showSignupForm.value = false;

                              },
                              child: const Text('Login'),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                showSignupForm.value = true;
                                showLoginForm.value = false;

                              },
                              child: const Text('Create an account'),
                            ),
                          ],
                        );
                      }
                    }),
                  ),
                ),
              ),
            ),
          ),
        )
            : const SizedBox.shrink(),
      )),
    );
  }


  Widget floatingMessageButton() => FloatingActionButton(
    backgroundColor: Colors.deepPurple,
    onPressed: () async {
      _openChatPopup();
    },
    child: Obx(() => Icon(
      showChatBox.value ? Icons.close : Icons.chat_bubble_outline,
      color: Colors.white,
    )),
  );

  void _openChatPopup() {
    showChatBox.value = !showChatBox.value;
    showLoginForm.value = false;
    showSignupForm.value = false;
    showRoleSelection.value = false;

    // Check if the user is already logged in
    if (FirebaseAuth.instance.currentUser != null) {
      // User is already logged in, generate chatRoomId and show chat screen
      String chatRoomId = logic.generateChatRoomId(
        FirebaseAuth.instance.currentUser!.uid,
        logic.fixedAdminId,
      );
      logic.chatRoomIdForPopup.value = chatRoomId;
      logic.receiverIdForPopup.value = logic.fixedAdminId;
      logic.receiverNameForPopup.value = logic.adminName;
      logic.showChatScreen.value = true;
    } else {
      // Show login/signup options
      showRoleSelection.value = showChatBox.value; // Show role selection on opening chatbox

    }
  }

  /// Login State setting of role is performed
  Widget _buildRoleSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {

              isStudent = true;
              userRole = 'student';
              showRoleSelection.value = false;
              showSignupForm.value = true;

            },
            child: Text('Login as Student'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {

              isStudent = false;
              userRole = 'client'; // Also setting the userRole
              showRoleSelection.value = false;
              showLoginForm.value = true; // Show login form after role selection

            },
            child: Text('Login as Client'),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width:300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple, // Primary Color
                ),
              ),
              const Gap(15),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const Gap(12),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const Gap(12),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                obscureText: true,
              ),
              const Gap(12),

              // const Gap(12),
              if (isStudent)
                Expanded(
                  // or Flexible if you don't want it to take all available space
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Course',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    value: selectedCourse,
                    items: courses.map((String course) {
                      return DropdownMenuItem<String>(
                        value: course,
                        child: Text(course),
                      );
                    }).toList(),
                    onChanged: (String? value) {

                      selectedCourse = value;

                    },
                    validator: (value) => value == null ? 'Please select a course' : null,
                  ),
                ),
              const Gap(12),
              ElevatedButton(
                onPressed: () async {
                  if (selectedCourse != null) {
                    await logic.createUserWithEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                      selectedCourse!,
                      isStudent: isStudent,
                    );
                    if (logic.auth.currentUser != null) {
                      showSignupForm.value = false;

                    }
                  } else {
                    Get.snackbar('Error', 'Please select a course');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Primary Color
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Gap(4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: TextButton(
                  key: ValueKey<bool>(showLoginForm.value),
                  onPressed: () {

                    showSignupForm.value = false;
                    showLoginForm.value = true;

                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple, // Primary Color
            ),
          ),
          const Gap(24),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const Gap(16),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            obscureText: true,
          ),
          const Gap(32),

          Obx(()=>   courseLogic.isLoading.value == true?CircularProgressIndicator(): ElevatedButton(
            onPressed: () async {

              await courseLogic.signInWithEmailAndPassword(emailController.text, passwordController.text);
              if (logic.auth.currentUser != null) {

                _openChatPopup(); // Open Chat Popup
                showSignupForm.value = false;
                showLoginForm.value = false;


              }



            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, // Primary Color
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),),
          const Gap(16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: TextButton(
              key: ValueKey<bool>(showSignupForm.value),
              onPressed: () {

                showLoginForm.value = false;
                showSignupForm.value = true;

              },
              child: const Text(
                'Create an account',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                  title: Image.asset(
                    'assets/images/logo_white.png',
                    height: 120,
                  ),
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

                    // Login Function
                    StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // User is logged in. Show Logout and possibly Dashboard.

                          List<Widget> buttons = [
                            TextButton(
                              onPressed: () {
                                courseLogic.logOut();
                                showChatBox.value = !showChatBox.value;
                                showLoginForm.value = false;
                                showSignupForm.value = false;
                                showRoleSelection.value = true;
                                logic.showChatScreen.value = false;

                              },
                              child: Text('Logout'.tr),
                            )
                          ];

                          if (userRole == 'student') {
                            buttons.add(TextButton(
                              onPressed: () {
                                Get.toNamed("/dashboard");
                                // Get.toNamed('/dashboard');
                              },
                              child: Text('Dashboard'.tr),
                            ));
                          }

                          return Row(children: buttons);
                        } else {
                          // User is not logged in
                          return TextButton(
                            onPressed: () {
                              _openChatPopup();
                              showRoleSelection.value = true;
                              // showChatBox = true;

                            },
                            child: Text('Login'.tr),
                          );
                        }
                      },
                    ),

                    const Gap(10),
                    // Language selector
                    Container(
                      width: 85,
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
                            DropdownMenuItem(value: 'ur', child: Text('اردو')),
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
                body:
                    SingleChildScrollView(
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
                          const Gap(6),
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

                          AnimatedOnScroll(child: WhyLaunchCodeSection(key: _whyUsKey)),
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
              Obx(() =>showChatBox.value ?
              chatPopup(): SizedBox()),
            ],
          );
        },
      ),
    );
  }

  var greyBackSize = 800.0;
  final planRowKey = GlobalKey();

  Widget _buildLaunchCodeHero(BuildContext ctx) {
    final width = MediaQuery.of(ctx).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
          ResponsiveBreakpoints.of(context).isMobile
              ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Gap(8),
                  Text(
                    'launch_sooner'.tr,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 28),
                  Gap(8),
                  Text(
                    'grow_faster'.tr,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Gap(8),
                  Text(
                    'launch_sooner'.tr,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 28),
                  Gap(8),
                  Text(
                    'grow_faster'.tr,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
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
          const Gap(6),
          Padding(
            key: _featuredKey,
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: const FeaturedProductsSection(),
          ),

          // const Gap(16),
          Container(
            height:      ResponsiveBreakpoints.of(context).isMobile? 510:330, // Adjusted height to fit everything comfortably
            color: Colors.white,
            alignment: Alignment.topCenter,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      // width: greyBackSize,
                      child: Lottie.asset('assets/lotties/myBack.json'),
                    ),
                    Text(
                      "Choose your Plan".tr, // Example text
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        // Add other styling as needed
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                // Your existing SizedBox containing the ListView
                Center(
                  key: planRowKey,
                  child:
                  ResponsiveBreakpoints.of(context).isMobile?Column(
                    children: [
                      PlanCard(
                        text: "BASIC PLAN".tr,
                        price: 199,
                        supportDays: "Mon-Fri".tr,
                        deliveryTime: "8 Days".tr,
                      ),
                      const SizedBox(height: 12),
                      PlanCard(
                        text: "ADVANCED PLAN".tr,
                        price: 449,
                        supportDays: "Mon-Sun".tr,
                        deliveryTime: "5 Days".tr,
                      ),
                    ],
                  ):
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PlanCard(
                        text: "BASIC PLAN".tr,
                        price: 199,
                        supportDays: "Mon-Fri".tr,
                        deliveryTime: "8 Days".tr,
                      ),
                      const SizedBox(width: 12),
                      PlanCard(
                        text: "ADVANCED PLAN".tr,
                        price: 399,
                        supportDays: "Mon-Sun".tr,
                        deliveryTime: "5 Days".tr,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Stack(
            //   alignment: Alignment.bottomCenter,
            //   children: [
            //     // ResponsiveBreakpoints.of(context).isMobile
            //     //     ? Container()
            //     //     : SizedBox(
            //     //       height: 300,
            //     //       child: ListView(
            //     //         scrollDirection: Axis.horizontal,
            //     //         physics: NeverScrollableScrollPhysics(),
            //     //         children: [
            //     //           // SizedBox(
            //     //           //   height: 600,
            //     //           //   width: greyBackSize,
            //     //           //   child: Lottie.asset('assets/lotties/myGreyBack.json'),
            //     //           // ),
            //     //           SizedBox(
            //     //             height: 600,
            //     //             width: greyBackSize,
            //     //             child: Lottie.asset('assets/lotties/myBack.json'),
            //     //           ),
            //     //
            //     //         ],
            //     //       ),
            //     //     ),
            //
            //
            //
            //
            //     // LayoutBuilder(
            //     //   builder: (context, constraints) {
            //     //     return Column( // Wrap with a Column
            //     //       mainAxisSize: MainAxisSize.min, // Important to prevent Column from taking infinite height
            //     //       children: [
            //     //         // Your Text widget here
            //     //
            //     //
            //     //       ],
            //     //     );
            //     //   },
            //     // )
            //
            //     // 🟢 Lottie animation at the bottom
            //   ],
            // ),
          ),
        ],
      ),
    );
  }

// void setState(Null Function() param0) {
//   super.setState(() {});
// }
}