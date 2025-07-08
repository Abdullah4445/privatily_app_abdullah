import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../screens/Home/home.dart';

class ResponsivePage extends StatefulWidget {
  const ResponsivePage({Key? key}) : super(key: key);

  @override
  State<ResponsivePage> createState() => _ResponsivePageState();
}

class _ResponsivePageState extends State<ResponsivePage> {
  @override
  Widget build(BuildContext context) {
    final ScreenType = ResponsiveBreakpoints.of(context);
    return Scaffold(
      body:
          ScreenType.largerThan(TABLET)
              ? showDesktopScreen(context)
              : ScreenType.largerThan(MOBILE)
              ? showTabletScreen(context)
              : showMobileScreen(context),
    );
  }

  showMobileScreen(BuildContext context) {
    return HomePage();
  }

  showTabletScreen(context) {
    return HomePage();
  }

  showDesktopScreen(context) {
    return HomePage();
  }
}
