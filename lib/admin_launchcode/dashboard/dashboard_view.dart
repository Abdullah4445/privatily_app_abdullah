import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../chatting_page/chatting_page_view.dart';
import '../home_page/logic.dart';
import '../home_page/view.dart';
import '../projects/projects.dart';
import '../screens/coursescreen.dart';
import '../screens/driver.dart';
import '../screens/home.dart';
import '../screens/project_comments/project_comments_view.dart';
import '../screens/project_reviews/project_reviews_view.dart';
import '../screens/reviews.dart';
import '../screens/setting.dart';
import '../screens/students_screen/students.dart';
import '../screens/reviews.dart';

import '../side_menu/side_menu.dart';
import 'dashboard_logic.dart';
import 'dashboard_state.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final AdminDashboardLogic logic = Get.put(AdminDashboardLogic());
  final LogicadminHome homeLogic = Get.put(LogicadminHome());

  final DashboardState state = Get.find<AdminDashboardLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(),
          Expanded(
            child: Obx(() {
              var selectedIndex = logic.selectedScreenIndex.value;
              // final homeLogic = Get.find<HomeLogic>();

              switch (selectedIndex) {
                case 0:
                  return HomeScreen();
                case 1:
                  return ProjectScreen();
                case 2:
                  return ProjectReviewsPage();
                case 3:
                  return ProjectCommentsView();
                case 4:
                  return CourseScreen();
                case 5:
                  return ReviewsScreen();
                case 6:
                  return AdminChatHome();
                case 7:
                  return StudentsScreen();
                case 8:
                  return DriverScreen();
                case 9:
                  return SettingsScreen();
                default:
                  return HomeScreen();
              }
            }),
          ),
        ],
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return Scaffold(
          appBar: isMobile
              ? AppBar(
            title: Text('Admin Panel'),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          )
              : null,
          drawer: isMobile ? Drawer(child: SideMenu()) : null,
          body: Row(
            children: [
              if (!isMobile)
                SizedBox(
                  width: 250,
                  child: SideMenu(),
                ),
              Expanded(
                child: Obx(() {
                  var selectedIndex = logic.selectedScreenIndex.value;
                  switch (selectedIndex) {
                    case 0:
                      return HomeScreen();
                    case 1:
                      return ProjectScreen();
                    case 2:
                      return ProjectReviewsPage();
                    case 3:
                      return ProjectCommentsView();
                    case 4:
                      return CourseScreen();
                    case 5:
                      return ReviewsScreen();
                    case 6:
                      return StudentsScreen();
                    case 7:
                      return DriverScreen();
                    case 8:
                      return SettingsScreen();
                    default:
                      return HomeScreen();
                  }
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    Get.delete<AdminDashboardLogic>();
    super.dispose();
  }
}
