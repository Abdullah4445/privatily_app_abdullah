// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
//
// import 'logic.dart';
//
// class SignUpPopup extends StatefulWidget {
//   final VoidCallback onSignedUp; // Callback function
//   final VoidCallback toggleSignUp;
//
//   const SignUpPopup({Key? key, required this.onSignedUp, required this.toggleSignUp}) : super(key: key);
//
//   @override
//   State<SignUpPopup> createState() => _SignUpPopupState();
// }
//
// class _SignUpPopupState extends State<SignUpPopup> {
//   final Login_pageLogic logic = Get.find<Login_pageLogic>();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 "Sign-Up",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 24,
//                   color: Colors.deepPurple,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const Gap(10),
//               TextFormField(
//                 controller: logic.nameC,
//                 decoration: InputDecoration(
//                   hintText: "Enter name",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   prefixIcon: const Icon(Icons.person, color: Colors.deepPurple),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your name";
//                   }
//                   return null;
//                 },
//               ),
//               const Gap(10),
//               TextFormField(
//                 controller: logic.emailC,
//                 decoration: InputDecoration(
//                   hintText: "Enter Email",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your email";
//                   }
//                   if (!value.contains('@')) {
//                     return "Please enter a valid email";
//                   }
//                   return null;
//                 },
//               ),
//               const Gap(10),
//               TextFormField(
//                 controller: logic.passC,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Enter password",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your password";
//                   }
//                   if (value.length < 6) {
//                     return "Password must be at least 6 characters";
//                   }
//                   return null;
//                 },
//               ),
//               const Gap(20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     await logic.createUser();
//                     // Call the callback function after successful sign-up
//                     widget.onSignedUp();
//
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Sign Up",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//               const Gap(10),
//               TextButton(
//                 onPressed: () {
//                   // Switch to Sign In
//                   widget.toggleSignUp();
//                 },
//                 child: const Text(
//                   "Already have an account? Sign In",
//                   style: TextStyle(fontSize: 16, color: Colors.deepPurple),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }