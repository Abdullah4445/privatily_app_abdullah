import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
          child: showLoginForm
              ? buildLoginForm()
              : showSignupForm
              ? buildSignupForm()
              : buildChatButtons(),
        )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPopupHeader("Login"),
        const SizedBox(height: 16),
        CustomInputField(controller: logic.emailC, hintText: 'Email'),
        const SizedBox(height: 12),
        CustomInputField(controller: logic.passC, hintText: 'Password', isPassword: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => logic.signIn(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, minimumSize: const Size.fromHeight(50)),
          child: const Text("Login", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPopupHeader("Sign Up"),
        const SizedBox(height: 16),
        CustomInputField(controller: logic.NameC, hintText: 'User Name'),
        const SizedBox(height: 12),
        CustomInputField(controller: logic.emailC, hintText: 'Email'),
        const SizedBox(height: 12),
        CustomInputField(controller: logic.passC, hintText: 'Password', isPassword: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => logic.createUser(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, minimumSize: const Size.fromHeight(50)),
          child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildPopupHeader(String title) {
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() {
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
            onPressed: () => setState(() {
              showLoginForm = true;
              showSignupForm = false;
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {
              showSignupForm = true;
              showLoginForm = false;
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: const Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
          ),
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

  Widget _buildLaunchCodeHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
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
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 16,
            children: const [
              Icon(Icons.rocket_launch, color: Colors.deepPurple, size: 30),
              Text("Launch Sooner.", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Icon(Icons.trending_up, color: Colors.green, size: 30),
              Text("Grow Faster.", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          const Gap(40),
          const Text(
            "Discover Ready-to-Use Software Scripts to Power Your Business.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const Gap(30),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.explore, color: Colors.white),
                label: const Text("Explore Products", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.code),
                label: const Text("Browse Categories"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  side: const BorderSide(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return DraggableHome(
      headerExpandedHeight: 300,
      headerBottomBar: ,
      title: Row(
        children: [
          Image.asset("assets/images/logo_white.png", height: 120),
        ],
      ),
      headerWidget: _buildLaunchCodeHero(context),
      body: [_myBody(context, screenWidth)],
    );
  }

  Widget _myBody(context, screenWidth) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(10),
              const FeaturedProductsSection(),
              const Gap(60),
              Text(
                'Launch your digital product\nin just a few clicks',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth < 600 ? 28 : screenWidth < 1024 ? 40 : 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(20),
              Text(
                'Save time and skip the hassle—choose from high-converting scripts, apps, and admin panels already built for success. Just deploy and start earning!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: screenWidth < 600 ? 14 : 16, color: Colors.black87),
              ),

              const Gap(10),
              fiveStars(screenWidth),
              const Gap(30),
              const AnimatedOnScroll(child: PrivatilyPreviewImage()),
              const AnimatedOnScroll(child: HomeStatsSection()),
              const AnimatedOnScroll(child: WhyLaunchCodeSection()),
              const AnimatedOnScroll(child: PremiumBonusSection()),
              const AnimatedOnScroll(child: HowMuchTimeSection()),
              const AnimatedOnScroll(child: WhyIncorporateUsSection()),
              const AnimatedOnScroll(child: TransparentPricingSection()),
              AnimatedOnScroll(
                child: Container(key: _testimonialKey, child: const TestimonialSection()),
              ),
              const AnimatedOnScroll(child: OurMissionSection()),
              const AnimatedOnScroll(child: FaqSection()),
              const AnimatedOnScroll(child: LaunchAnywhereSection()),
              const AnimatedOnScroll(child: ContactUsSection()),
              const AnimatedOnScroll(child: FooterSection()),
            ],
          ),
        ),
        chatPopup(),
        floatingMessageButton(),
      ],
    );
  }
}
