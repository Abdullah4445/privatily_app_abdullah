import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:privatily_app/login_screen/sign-up_view.dart';
import '../home_page/view.dart';
import 'logic.dart';

class SignIn_page extends StatefulWidget {
  SignIn_page({Key? key}) : super(key: key);

  @override
  State<SignIn_page> createState() => _SignIn_pageState();
}

class _SignIn_pageState extends State<SignIn_page> {
  final Login_pageLogic logic = Get.put(Login_pageLogic());
  bool _isObscure = true;

  Future<void> _initialize() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("My user is not null");
      Future.delayed(const Duration(seconds: 2));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.network(
                    'https://lottie.host/230db473-bae4-4f7b-b597-5466e1072f60/74TD71RDUh.json',
                  ),
                ),
                Text(
                  "signin_title".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.red,
                  ),
                ),
                const Gap(20),
                _inputField(
                  controller: logic.emailC,
                  hint: "signin_email_hint".tr,
                  icon: Icons.email,
                ),
                const Gap(20),
                _inputField(
                  controller: logic.passC,
                  hint: "signin_password_hint".tr,
                  icon: Icons.lock,
                  obscure: _isObscure,
                  suffix: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                const Gap(30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => logic.signIn(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "signin_button".tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                TextButton(
                  onPressed: () => Get.to(SignUp()),
                  child: Text(
                    "signin_signup_prompt".tr,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.red),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
