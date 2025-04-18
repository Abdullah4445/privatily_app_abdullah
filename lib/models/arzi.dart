// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:privatily_app/preview/privatily_preview_image.dart';
// import '../chat_page/logic.dart';
// import '../chat_page/view.dart';
// import '../home_page/logic.dart';
// import '../home_page/view.dart';
// import '../login_screen/logic.dart';
// import '../login_screen/view.dart';
// import '../models/messages.dart';
// import '../models/students.dart';
// import '../mytextfield/custom_field.dart';
// import '../sections/FAQ_section.dart';
// import '../sections/FooterSection.dart';
// import '../sections/contact_us_seaction.dart';
// import '../sections/home_stats_section.dart';
// import '../sections/how_much_time_section.dart';
// import '../sections/launch_any_whered_ection.dart';
// import '../sections/our_mission_section.dart';
// import '../sections/testimonial_section.dart';
// import '../sections/transparent_pricing_seaction.dart';
// import '../sections/why_incorporate_us_section.dart';
// import '../sections/why_privatily_section.dart';
// import '../animations/animated_on_scrool.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   final ScrollController _scrollController = ScrollController();
//   final Login_pageLogic logic = Get.put(Login_pageLogic());
//   final HomeLogic logic2 = Get.put(HomeLogic());
//
//
//   final GlobalKey _testimonialKey = GlobalKey();
//   bool showChatBox = false;
//
//   // Future<void> _initialize() async {
//   //   User? user = FirebaseAuth.instance.currentUser;
//   //   if (user != null) {
//   //     print("My user is not null");
//   //     Future.delayed(const Duration(seconds: 2));
//   //     WidgetsBinding.instance.addPostFrameCallback((_) {
//   //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePages()));
//   //     });
//   //   }
//   // }
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _initialize();
//   // }
//
//
//   void scrollToTestimonials() {
//     final RenderBox renderBox = _testimonialKey.currentContext!.findRenderObject() as RenderBox;
//     final position = renderBox.localToGlobal(Offset.zero, ancestor: null).dy;
//     _scrollController.animateTo(
//       position + _scrollController.offset,
//       duration: const Duration(milliseconds: 800),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   Widget fiveStars(double screenWidth) {
//     double iconSize = screenWidth < 600 ? 18 : screenWidth < 1024 ? 22 : 26;
//     return GestureDetector(
//       onTap: scrollToTestimonials,
//       child: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: List.generate(5, (index) {
//                 return Icon(Icons.star, color: Colors.orange, size: iconSize);
//               }),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               'Rated 4.2+ stars by entrepreneurs worldwide',
//               style: TextStyle(fontSize: iconSize * 0.6, fontWeight: FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// // Declare showHomeScreen as RxBool
//   var showHomeScreen = false.obs;  // Make it observable using .obs
//   bool showLoginForm = false;
//   bool showSignupForm = false;
//   var showChatScreen = false.obs;
//   Widget chatPopup() {
//     return Positioned(
//       bottom: 100,
//       right: 24,
//       child: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: showChatBox
//             ? Container(
//           key: const ValueKey('chatbox'),
//           width: 360,
//           height: 480,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: const [
//               BoxShadow(color: Colors.black26, blurRadius: 25)
//             ],
//           ),
//           child: Obx(() => logic2.showChatScreen.value
//               ? ChattingPage(
//             chatRoomId: logic2.chatRoomIdForPopup.value,
//             receiverId: logic2.receiverIdForPopup.value,
//             receiverName: logic2.receiverNameForPopup.value,
//           )
//               : logic.showHomeScreen.value
//               ? Homes()
//               : showLoginForm
//               ? buildLoginForm()
//               : showSignupForm
//               ? buildSignupForm()
//               : buildInitialButtons()),
//         )
//             : const SizedBox.shrink(),
//       ),
//     );
//   }
//
//   Widget buildLoginForm() {
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Expanded(
//               child: Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             ),
//             IconButton(
//               icon: const Icon(Icons.close),
//               onPressed: () {
//                 setState(() {
//                   showChatBox = false;
//                   showLoginForm = false;
//                   showSignupForm = false;
//                 });
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         CustomInputField(controller: logic.emailC, hintText: 'Email'),
//         const SizedBox(height: 12),
//         CustomInputField(controller: logic.passC, hintText: 'Password', isPassword: true),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () async {
//             // SignIn method now checks the login result and updates the screen accordingly
//             await logic.signIn();
//
//             // Update the UI only if login is successful
//             if (FirebaseAuth.instance.currentUser != null) {
//               setState(() {
//                 showHomeScreen = true.obs; // Show HomePage only after successful login
//               });
//             } else {
//               Get.snackbar("Error", "Login failed. Please try again.");
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepPurple,
//             minimumSize: const Size.fromHeight(50),
//           ),
//           child: const Text("Login", style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
//
//
//   Widget buildSignupForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Expanded(
//               child: Text("Sign Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             ),
//             IconButton(
//               icon: const Icon(Icons.close),
//               onPressed: () {
//                 setState(() {
//                   showChatBox = false;
//                   showLoginForm = false;
//                   showSignupForm = false;
//                 });
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         CustomInputField(controller: logic.NameC, hintText: 'User Name'),
//         const SizedBox(height: 12),
//         CustomInputField(controller: logic.emailC, hintText: 'Email'),
//         const SizedBox(height: 12),
//         CustomInputField(controller: logic.passC, hintText: 'Password', isPassword: true),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () async {
//             await logic.createUser(); // Your signup logic
//             setState(() {
//               showHomeScreen = true.obs;
//             });
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepPurple,
//             minimumSize: const Size.fromHeight(50),
//           ),
//           child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
//
//   Widget buildInitialButtons() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 showLoginForm = true;
//                 showSignupForm = false;
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//             ),
//             child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 showSignupForm = true;
//                 showLoginForm = false;
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple.shade100,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//             ),
//             child: const Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//
//   Widget chatBubble({required IconData icon, required String time, required String text, String? inputHint}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(backgroundColor: Colors.deepPurple.shade50, child: Icon(icon, color: Colors.deepPurple)),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF1F4FB),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(text, style: const TextStyle(fontSize: 14)),
//                   if (inputHint != null) ...[
//                     const SizedBox(height: 10),
//                     TextField(
//                       decoration: InputDecoration(
//                         hintText: inputHint,
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(time, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
//         ],
//       ),
//     );
//   }
//
//   Widget floatingMessageButton() {
//     return Positioned(
//       bottom: 24,
//       right: 24,
//       child: FloatingActionButton(
//         backgroundColor: Colors.deepPurple,
//         onPressed: () => setState(() => showChatBox = !showChatBox),
//         child: Icon(showChatBox ? Icons.close : Icons.chat_bubble_outline, color: Colors.white),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             controller: _scrollController,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Gap(60),
//                 Text(
//                   'Form your company\nfrom anywhere',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: screenWidth < 600 ? 28 : screenWidth < 1024 ? 40 : 50,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Gap(20),
//                 Text(
//                   'Join the thousands of entrepreneurs using our platform to incorporate their\ncompanies and unlock premium payment & banking options.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: screenWidth < 600 ? 14 : 16, color: Colors.black87),
//                 ),
//                 const Gap(10),
//                 fiveStars(screenWidth),
//                 const Gap(30),
//                 AnimatedOnScroll(child: const PrivatilyPreviewImage()),
//                 AnimatedOnScroll(child: const HomeStatsSection()),
//                 AnimatedOnScroll(child: const WhyPrivatilySection()),
//                 AnimatedOnScroll(child: const HowMuchTimeSection()),
//                 AnimatedOnScroll(child: const WhyIncorporateUsSection()),
//                 AnimatedOnScroll(child: const TransparentPricingSection()),
//                 AnimatedOnScroll(
//                   child: Container(
//                     key: _testimonialKey,
//                     child: const TestimonialSection(),
//                   ),
//                 ),
//                 AnimatedOnScroll(child: const OurMissionSection()),
//                 AnimatedOnScroll(child: const FaqSection()),
//                 AnimatedOnScroll(child: const LaunchAnywhereSection()),
//                 AnimatedOnScroll(child: const ContactUsSection()),
//                 AnimatedOnScroll(child: const FooterSection()),
//               ],
//             ),
//           ),
//           chatPopup(),
//           floatingMessageButton(),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
