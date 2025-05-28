import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LaunchSteps extends StatefulWidget {
  const LaunchSteps({super.key});

  @override
  State<LaunchSteps> createState() => _LaunchStepsState();
}

class _LaunchStepsState extends State<LaunchSteps> {
  int _hoveredIndex = -1;

  final List<Map<String, dynamic>> steps = [
    {
      'icon': Icons.dashboard_customize,
      'title': 'Select Script'.tr,
      'subtitle': 'Choose from our Ready Made products.'.tr,
    },
    {
      'icon': Icons.assignment,
      'title': 'Provide Details'.tr,
      'subtitle': 'Logo, name, accounts, hosting.'.tr,
    },
    {
      'icon': Icons.build_circle,
      'title': 'Configuration'.tr,
      'subtitle': 'We customize and send you test links.'.tr,
    },
    {
      'icon': Icons.cloud_upload,
      'title': 'Upload & Confirm'.tr,
      'subtitle': 'You confirm and apps are submitted to your stores.'.tr,
    },
    {
      'icon': Icons.attach_money,
      'title': 'Monitor & Earn'.tr,
      'subtitle': 'Watch installs & revenue grow.'.tr,
    },
    {
      'icon': Icons.campaign,
      'title': 'SMM (Optional)'.tr,
      'subtitle': 'We can serve to market your product'.tr,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Gap(12), // Add a Spacer at the beginning
            Flexible(
              child: FocusableActionDetector(
                autofocus: true,
                mouseCursor: SystemMouseCursors.click,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true, // Change to true to only take necessary width
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    final isHovered = _hoveredIndex == index;
                    final bool isLast = index == steps.length - 2;
                    final bool isLastAho = index == steps.length - 1;

                    return MouseRegion(
                      onEnter: (_) => setState(() => _hoveredIndex = index),
                      onExit: (_) => setState(() => _hoveredIndex = -1),
                      child: AnimatedScale(
                        scale: isHovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: Stack(
                          children: [
                            Container(
                              width: 220,
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(step['icon'], size: 30, color: Colors.redAccent),
                                  const SizedBox(height: 3),
                                  Text(
                                    'step_number'.trArgs([ (index + 1).toString() ]),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    step['title'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    step['subtitle'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: SizedBox(
                                width: isLast ? 110 : 72,
                                height: isLast ? 110 : 72,
                                child: isLastAho ? Container() : Lottie.asset(
                                  isLast
                                      ? 'assets/lotties/iwon.json'
                                      : 'assets/lotties/plane.json',
                                  repeat: true,
                                  animate: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Gap(12),  // Add a Spacer at the end
          ],
        ),
      ),
    );
  }

}
