// fullscreen_chat_widget.dart

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:privatily_app/widgets/homellogic.dart';

import '../modules/chat_page/chat/view/chatting_page.dart'; // Assuming this is in the correct relative path

class FullscreenChatWidget extends StatelessWidget {
  final HomeLogic logic = Get.find(); // Get the existing instance

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool showLoginForm = false.obs;
  RxBool showSignupForm = false.obs;
  RxBool showRoleSelection = false.obs;

  bool isStudent = false;

  String? selectedCourse;
  String? userRole;

  List<String> courses = [];

  FullscreenChatWidget({super.key}){
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    courses = await logic.getCoursesFromFirestore();
    // No need to setState here, as this is a stateless widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.back(); // Close the fullscreen view
          },
        ),
        title: const Text('Chat/Authentication'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (logic.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
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
    );
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
            child: const Text('Login as Student'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              isStudent = false;
              userRole = 'client'; // Also setting the userRole
              showRoleSelection.value = false;
              showLoginForm.value = true; // Show login form after role selection
            },
            child: const Text('Login as Client'),
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
              const Text(
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
                    //if (logic.auth.currentUser != null) {
                    //showSignupForm.value = false;
                    //}
                    Get.back();  //close popup after sign up
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
          const Text(
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

          Obx(()=>   logic.isLoading.value == true?const CircularProgressIndicator(): ElevatedButton(
            onPressed: () async {
              await logic.signInWithEmailAndPassword(emailController.text, passwordController.text);
              Get.back();  //close popup after sign in

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
}