import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Column(
        children: [
          Text('Settings for your account'),
          IconButton(onPressed: (){}, icon: Icon(Icons.logout_outlined))
        ],
      )),
    );
  }
}
