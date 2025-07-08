import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BAppbar extends StatelessWidget  {
  const BAppbar(
      {super.key,
        this.title,


        this.actions, this.profile,
     });

  final Widget? title;
  final Widget? profile;


  final List<Widget>? actions;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppBar(backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        leading: profile,
        title: title,
        actions: actions,
      ),
    );
  }}