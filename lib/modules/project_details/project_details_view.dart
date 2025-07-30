// Redesigned ProjectDetailsPage with SEO-safe meta and injected JSON-LD manually via dart:html

// import 'dart:html' as html;

import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:seo/seo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/products.dart';
import '../../utils/translationHelper.dart';
import '../../widgets/myProgressIndicator.dart';
import '../stepstolaunch/stepstolaunch.dart';
import 'comments/comments_section.dart';
import 'project_details_logic.dart';

class ProjectDetailsPage extends StatefulWidget {
  ProjectDetailsPage({super.key});

  // static const _horizontalPadding = 16.0;
  static const _accentColor = Color(0xFF00E676);

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  final logic = Get.put(ProjectDetailsLogic());

  late final ValueNotifier<bool> _readMoreCollapsedNotifier;

  // Disposer for the GetX reaction to prevent memory leaks
  // Corrected type: it's a Function, not ReactionDisposer
  late final Function _rxDisposer;

  @override
  void initState() {
    super.initState();

    // Initialize the ValueNotifier.
    // ReadMoreText's 'isCollapsed' expects 'true' for collapsed, 'false' for expanded.
    // Our 'isDescriptionExpanded' is 'true' for expanded, 'false' for collapsed.
    _readMoreCollapsedNotifier = ValueNotifier<bool>(!logic.isDescriptionExpanded.value);

    // Set up a listener on the ValueNotifier: whenever it changes,
    // update our RxBool.
    _readMoreCollapsedNotifier.addListener(() {
      logic.isDescriptionExpanded.value = !_readMoreCollapsedNotifier.value;
      print('ValueNotifier changed, logic.isDescriptionExpanded is now: ${logic.isDescriptionExpanded.value}');
    });
  }

  @override
  void dispose() {
    // Dispose the GetX reaction and the ValueNotifier when the widget is removed
    // _rxDisposer(); // We are now listening directly to the ValueNotifier, so no need for 'ever'
    _readMoreCollapsedNotifier.dispose();
    super.dispose();
  }
  Widget _backBtn(BuildContext ctx) => Padding(
    padding: const EdgeInsets.only(left: 12),
    child: CircleAvatar(
      backgroundColor: Colors.black12,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () {
          if (Navigator.canPop(ctx)) {
            Navigator.pop(ctx);
          } else {
            // html.window.location.href = '/';
          }
        },
      ),
    ),
  );

  PreferredSizeWidget _buildAppBar(Project p) => AppBar(
    backgroundColor: Colors.white,
    elevation: 4,
    iconTheme: const IconThemeData(color: Colors.black87),
    leading: _backBtn(context),
    centerTitle: true,
    title: Text(p.title ?? '',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    bottom: TabBar(
      indicatorColor: Colors.blue.shade400,
      labelColor: Colors.black87,
      tabs: const [
        Tab(text: 'Item Details'),
        Tab(text: 'Item Comments'),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          if (!logic.isProductLoaded) return const Center(child: MyLoader());
          final product = logic.product.value;
          if (product == null) return const Center(child: Text('Product not found.'));

          // Inject JSON-LD structured data
          // final jsonLdScript =
          // html.ScriptElement()
          //   ..type = 'application/ld+json'
          //   ..text = '''
          //     {
          //       "@context": "https://schema.org",
          //       "@type": "Product",
          //       "name": "${product.title}",
          //       "description": "${product.projectDesc}",
          //       "image": ${logic.imagesToShow.map((url) => '"$url"').toList()},
          //       "offers": {
          //         "@type": "Offer",
          //         "availability": "https://schema.org/InStock"
          //       }
          //     }
          //   ''';
          // html.document.head!.append(jsonLdScript);

          return Seo.head(
            tags: [
              MetaTag(name: 'title', content: product.title ?? 'Project Details'),
              MetaTag(name: 'description', content: product.projectDesc ?? ''),
              LinkTag(
                rel: 'canonical',
                href: 'https://launchcode.shop/product-detail/${product.projectId}',
              ),
              MetaTag(name: 'og:title', content: product.title ?? ''),
              MetaTag(name: 'og:description', content: product.projectDesc ?? ''),
              MetaTag(
                name: 'og:url',
                content: 'https://launchcode.shop/product-detail/${product.projectId}',
              ),
              if (logic.imagesToShow.isNotEmpty)
                MetaTag(name: 'og:image', content: logic.imagesToShow.first),
              MetaTag(name: 'twitter:card', content: 'summary_large_image'),
            ],
            child: Scaffold(
                appBar:   _buildAppBar(product),
                body: TabBarView(children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Gap(8),
                          _buildHeader(context, product),
                          const SizedBox(height: 24),
                          _buildSectionTitle(context, 'description'),
                          const SizedBox(height: 8),
                          ResponsiveBreakpoints.of(context).isMobile?Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 300, child: _buildDescription(context, product)),

                              Obx(() => AnimatedOpacity(
                                opacity: logic.isDescriptionExpanded.value ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Visibility(
                                  visible: logic.isDescriptionExpanded.value, // Only build if visible
                                  child: logic.buildThumbnail(context, product.thumbnailUrl),
                                ),
                              )),

                            ],
                          ): Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 300, child: _buildDescription(context, product)),

                              Obx(() => AnimatedOpacity(
                                opacity: logic.isDescriptionExpanded.value ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Visibility(
                                  visible: logic.isDescriptionExpanded.value, // Only build if visible
                                  child: logic.buildThumbnail(context, product.thumbnailUrl),
                                ),
                              )),
                            ],
                          ),
                          const SizedBox(height: 32),
                          if (product.demoAdminPanelLinks?.isNotEmpty ?? false)
                            ...product.demoAdminPanelLinks!.map(
                                  (panel) => _buildShotBlockWithDemo(
                                context,
                                panel.name,
                                panel.link,
                                panel.shotUrls,
                                logic,
                              ),
                            ),
                          if (product.demoApkLinks?.isNotEmpty ?? false)
                            ...product.demoApkLinks!.map(
                                  (apk) => _buildShotBlockWithDemo(
                                context,
                                apk.name,
                                apk.link,
                                apk.shotUrls,
                                logic,
                              ),
                            ),
                          if (product.mobileShotUrls?.isNotEmpty ?? false)
                            _buildShotBlockWithDemo(
                              context,
                              'Overview Screenshots',
                              null,
                              product.mobileShotUrls,
                              logic,
                            ),
                          Text(product.projectId.toString()),

                          const SizedBox(height: 105),
                        ],
                      ),
                    ),
                  ),
                  CommentsSection(projectId: product.projectId ?? ''),
                ])
            ),
          );
        }),

        // ... inside your main build method for ProjectDetailsPage ...
        floatingActionButton: Obx(() {
          // Wrap with Obx to listen to logic.product.value
          final currentProduct = logic.product.value; // Get the current product

          // If the product isn't loaded yet, you might want to show nothing or a placeholder
          if (currentProduct == null && logic.isProductLoaded) {
            // Product is null even after loading attempt, or still loading
            // You might want to return null or an empty SizedBox for the FAB
            return MyLoader(); // Or const SizedBox.shrink();
          }
          // If product is still loading (isProductLoaded is false), you might also return null or a loader
          if (!logic.isProductLoaded) {
            return MyLoader(); // Or a small loading indicator for the FAB area
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile: Use Column
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    HowToEarnButton(),
                    Gap(6),
                    // Conditionally display RequestSetup
                    if (currentProduct != null) RequestSetup(product: currentProduct),
                    // If currentProduct is null here, RequestSetup won't be built
                  ],
                );
              } else {
                // Tablet/desktop: Use Row
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    HowToEarnButton(),
                    Gap(12),
                    // Conditionally display RequestSetup
                    if (currentProduct != null) RequestSetup(product: currentProduct),
                    // If currentProduct is null here, RequestSetup won't be built
                  ],
                );
              }
            },
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Project product) {
    // Get the base style
    TextStyle? baseTitleStyle = Theme.of(
      context,
    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);

    // Determine the final style using ResponsiveBreakpoints
    TextStyle? finalTitleStyle = baseTitleStyle;

    if (ResponsiveBreakpoints.of(context).isMobile) {
      // Check if it's MOBILE breakpoint
      finalTitleStyle = baseTitleStyle?.copyWith(
        fontSize: 16, // Or some other size suitable for mobile
        color: Colors.white,
        // e.g., baseTitleStyle.fontSize! * 0.8 if you want it relative
      );
    }
    // You could add more conditions for TABLET, DESKTOP if needed
    // else if (ResponsiveBreakpoints.of(context).isTablet) {
    //   finalTitleStyle = baseTitleStyle?.copyWith(fontSize: 20);
    // }

    return Container(
      padding: EdgeInsets.only(  right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child:

            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 22.0,
                color: Colors.black54,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(  product.subtitle ?? '',
                      speed: const Duration(milliseconds: 80)),
                ],
                totalRepeatCount: 1, // Or set to null for infinite loop
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ),



          ),

          if ((product.soldCount ?? 0) > 0)
            Row(
              // Or Align if you want to position it differently
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40, // Adjust
                  height: 40, // Adjust
                  child: Lottie.asset('assets/lotties/rocket.json'), // Your Lottie
                ),
                const SizedBox(width: 6),
                Text.rich(
                  TextSpan(
                    text: 'Deployed: ', // The first part of the text
                    style: TextStyle(
                      color: Colors.teal[700], // Example color
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${product.soldCount ?? 0} Times',
                        // The part you want bold
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // Apply bold specifically here
                          // Inherit other styles like color and fontSize from the parent TextSpan
                          // or explicitly set them if they need to be different.
                          color: Colors.teal[700],
                          // Keeping the same color for consistency
                          fontSize: 18, // Keeping the same font size
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) => Row(
    children: [
      Container(width: 4, height: 24, color: ProjectDetailsPage._accentColor),
      const SizedBox(width: 8),
      Text(
        title.tr,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    ],
  );

  Widget _buildDescription(BuildContext context, Project product) => Align(
    alignment: Alignment.topLeft,
    child: ReadMoreText(
      product.projectDesc ?? '',
      trimMode: TrimMode.Line,
      trimLines: 2,
      trimCollapsedText: 'Read More',
      trimExpandedText: 'Read Less',
      colorClickableText: Colors.black38,
      isCollapsed: _readMoreCollapsedNotifier, // Directly use the ValueNotifier
    ),
  );

  Widget _buildShotBlockWithDemo(
      BuildContext context,
      String? title,
      String? demoLink,
      List<String>? urls,
      ProjectDetailsLogic logic,
      ) {
    if (urls == null || urls.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<String>(
                  future: TranslationService.translateText(
                    title,
                    Get.locale?.languageCode ?? 'en',
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('...');
                    } else if (snapshot.hasError) {
                      return Text(title); // fallback to original
                    } else {
                      return Text(
                        snapshot.data ?? title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      );
                    }
                  },
                ),
                if (demoLink?.isNotEmpty ?? false)
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text('tryDemo'.tr),
                    onPressed: () => logic.launchUrlExternal(demoLink!),
                    style: TextButton.styleFrom(foregroundColor: ProjectDetailsPage._accentColor),
                  ),
              ],
            ),
          ),
        _buildImageList(context, urls, logic),
      ],
    );
  }

  Widget _buildImageList(
      BuildContext context,
      List<String> images,
      ProjectDetailsLogic logic,
      ) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder:
            (ctx, i) => GestureDetector(
          onTap: () => _openImageViewer(context, images, i),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.hardEdge,
            child: Seo.image(
              src: images[i],
              alt:
              'Screenshot ${i + 1} of ${logic.product.value?.title ?? 'product'}',
              child: Image.network(
                images[i],
                width: 150,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openImageViewer(BuildContext context, List<String> images, int initialIndex) {
    final swiperController = CardSwiperController();
    final transformationController = TransformationController();
    int currentIndex = initialIndex;
    double scale = 1.0;

    const double panDelta = 50.0;

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder:
          (_) => StatefulBuilder(
        builder:
            (ctx, setState) => Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // === Image Viewer with Swipe ===
              InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 1,
                maxScale: 5,
                transformationController: transformationController,
                child: CardSwiper(
                  controller: swiperController,
                  cardsCount: images.length,
                  initialIndex: initialIndex,
                  onSwipe: (prev, next, dir) {
                    setState(() {
                      currentIndex = next!;
                      scale = 1.0;
                      transformationController.value = Matrix4.identity();
                    });
                    return true;
                  },
                  cardBuilder:
                      (ctx, i, _, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Image.network(images[i], fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),

              // === Close Button ===
              Positioned(
                top: 32,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),

              // === Swipe Left Arrow ===
              if (currentIndex > 0)
                Positioned(
                  left: 16,
                  top: MediaQuery.of(context).size.height / 2 - 24,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        swiperController.swipe(CardSwiperDirection.left);
                        setState(() {
                          currentIndex--;
                          scale = 1.0;
                          transformationController.value = Matrix4.identity();
                        });
                      },
                    ),
                  ),
                ),

              // === Swipe Right Arrow ===
              if (currentIndex < images.length - 1)
                Positioned(
                  right: 16,
                  top: MediaQuery.of(context).size.height / 2 - 24,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        swiperController.swipe(CardSwiperDirection.right);
                        setState(() {
                          currentIndex++;
                          scale = 1.0;
                          transformationController.value = Matrix4.identity();
                        });
                      },
                    ),
                  ),
                ),

              // === Control Pad: Zoom + Pan Cluster ===
              Positioned(
                bottom: 32,
                right: 16,
                child: Column(
                  children: [
                    // Zoom In Button
                    CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.zoom_in, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            scale = (scale + 0.2).clamp(1.0, 5.0);
                            final focalPoint = MediaQuery.of(
                              context,
                            ).size.center(Offset.zero);
                            transformationController.value =
                            Matrix4.identity()
                              ..translate(
                                focalPoint.dx * (1 - scale),
                                focalPoint.dy * (1 - scale),
                              )
                              ..scale(scale);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    // D-Pad Container
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Up
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_drop_up,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                transformationController.value =
                                transformationController.value
                                  ..translate(0.0, panDelta);
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Left
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_left,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    transformationController.value =
                                    transformationController.value
                                      ..translate(panDelta, 0.0);
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              // Right
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_right,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    transformationController.value =
                                    transformationController.value
                                      ..translate(-panDelta, 0.0);
                                  });
                                },
                              ),
                            ],
                          ),
                          // Down
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                transformationController.value =
                                transformationController.value
                                  ..translate(0.0, -panDelta);
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Zoom Out Button
                    CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.zoom_out, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            scale = (scale - 0.2).clamp(1.0, 5.0);
                            final focalPoint = MediaQuery.of(
                              context,
                            ).size.center(Offset.zero);
                            transformationController.value =
                            Matrix4.identity()
                              ..translate(
                                focalPoint.dx * (1 - scale),
                                focalPoint.dy * (1 - scale),
                              )
                              ..scale(scale);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HowToEarnButton extends StatelessWidget {
  const HowToEarnButton({super.key});

  @override
  Widget build(BuildContext context) {
    // `ValueNotifier` lets us mutate scale inside a stateless widget
    final hover = ValueNotifier(false);

    return SizedBox(
      height: 30,
      width: 220,
      child: MouseRegion(
        onEnter: (_) => hover.value = true,
        onExit: (_) => hover.value = false,
        cursor: SystemMouseCursors.click,
        child: ValueListenableBuilder<bool>(
          valueListenable: hover,
          builder:
              (_, isHover, child) => AnimatedScale(
            duration: const Duration(milliseconds: 120),
            scale: isHover ? 1.04 : 1.0,
            child: child, // re-use the button widget below
          ),
          child: _ctaButton(context),
        ),
      ),
    );
  }

  /// Extracted for readability
  ElevatedButton _ctaButton(context) {
    return ElevatedButton.icon(
      onPressed:
          () => showDialog(
        context: context,
        builder:
            (ctx) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: [
              LaunchSteps(),
              Positioned(
                right: 8,
                top: 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      icon: const Icon(Icons.monetization_on, size: 18),
      label: Text(
        'How to earn with this?'.tr,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: .4,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 6,
        // padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        backgroundColor: const Color(0xFF006BFF),
        foregroundColor: Colors.white,
        shadowColor: const Color(0x33006BFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ).merge(
        ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith(
                (states) =>
            states.contains(WidgetState.hovered)
                ? Colors.white.withOpacity(.05)
                : null,
          ),
        ),
      ),
    );
  }
}

class RequestSetup extends StatelessWidget {
  final Project product;

  const RequestSetup({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // `ValueNotifier` lets us mutate scale inside a stateless widget
    final hover = ValueNotifier(false);

    return SizedBox(
      height: 30,
      width: 230,
      child: MouseRegion(
        onEnter: (_) => hover.value = true,
        onExit: (_) => hover.value = false,
        cursor: SystemMouseCursors.click,
        child: ValueListenableBuilder<bool>(
          valueListenable: hover,
          builder:
              (_, isHover, child) => AnimatedScale(
            duration: const Duration(milliseconds: 120),
            scale: isHover ? 1.04 : 1.0,
            child: child, // re-use the button widget below
          ),
          child: _ctaButton(context),
        ),
      ),
    );
  }

  /// Extracted for readability
  ElevatedButton _ctaButton(context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final whatsappUrl = Uri.parse(
          "https://wa.me/923058431046?text=${Uri.encodeComponent("I'm interested in your product: Name:${product.title} — id:${product.projectId}")}",
        );
        if (!await launchUrl(whatsappUrl)) {
          Get.snackbar('Error', 'Could not launch WhatsApp');
        }
      },
      icon: FaIcon(FontAwesomeIcons.whatsapp, size: 18),
      label: Text(
        'Request Info/Setup'.tr,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: .4,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 6,
        // padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        shadowColor: const Color(0x33006BFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ).merge(
        ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith(
                (states) =>
            states.contains(WidgetState.hovered)
                ? Colors.white.withOpacity(.05)
                : null,
          ),
        ),
      ),
    );
  }
}
