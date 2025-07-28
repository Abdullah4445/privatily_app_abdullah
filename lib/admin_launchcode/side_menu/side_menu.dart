import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard/dashboard_logic.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller=Get.put(AdminDashboardLogic());
    return Container(
      width: 250,
      color: Color(0xFF1D1F29),
      child: Column(
        children: [
          // User Info Section
          IconButton(
            onPressed: () {
              // Get.back();
              Get.offAllNamed('/');
            },
            icon: const Icon(Icons.arrow_back), //
          ),          UserAccountsDrawerHeader(

            accountName: Text('Samantha'),
            accountEmail: Text('samantha@email.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/person4.jpeg'),
            ),
            decoration: BoxDecoration(color: Colors.black87),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem('Home', 0, Icons.dashboard),
                _buildMenuItem('Projects', 1, Icons.import_contacts_rounded),
                _buildMenuItem('Projects Reviews', 2, Icons.reviews),
                _buildMenuItem('Projects Comments', 3, Icons.comment),
                _buildMenuItem('Course', 4, Icons.book),
                _buildMenuItem('Reviews', 5, Icons.star),
                _buildMenuItem('Chats', 6, Icons.mark_unread_chat_alt_sharp),
                _buildMenuItem('Students', 7, Icons.accessibility_new_sharp),
                _buildMenuItem('Driver', 8, Icons.car_rental_rounded),
                _buildMenuItem('Settings', 9, Icons.settings),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMenuItem(String title, int index, IconData leadingIcon) {
    final AdminDashboardLogic logic = Get.find<AdminDashboardLogic>();

    return Obx(() => ListTile(
      selected: logic.selectedScreenIndex.value == index,
      selectedTileColor: Colors.green.withOpacity(0.2), // Background color when selected
      leading: Icon(
        leadingIcon,
        color: logic.selectedScreenIndex.value == index ? Colors.green : Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: logic.selectedScreenIndex.value == index ? Colors.green : Colors.white,
          fontSize: 18,
        ),
      ),
      onTap: () {
        logic.changeScreen(index);
      },
    ));
  }


// Widget _buildMenuItem(String title, int index, IconData leadingIcon) {
  //   return ListTile(
  //     selectedColor: Colors.red,
  //     leading: Icon(leadingIcon, color: Colors.white),
  //     title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
  //     onTap: () {
  //       Get.find<DashboardLogic>().changeScreen(
  //         index,
  //       ); // Change the screen content based on index
  //     },
  //   );
  // }
}
