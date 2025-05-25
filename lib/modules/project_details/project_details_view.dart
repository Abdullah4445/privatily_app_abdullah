// Redesigned ProjectDetailsPage with SEO-safe meta and injected JSON-LD manually via dart:html

import 'dart:html' as html;

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:seo/seo.dart';

import '../../models/products.dart';
import '../../utils/translationHelper.dart';
import '../../widgets/myProgressIndicator.dart';
import '../stepstolaunch/stepstolaunch.dart';
import 'project_details_logic.dart';

class ProjectDetailsPage extends StatelessWidget {
  ProjectDetailsPage({super.key});

  static const _horizontalPadding = 16.0;
  static const _accentColor = Color(0xFF00E676);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ProjectDetailsLogic());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (!logic.isProductLoaded) return const Center(child: MyLoader());
        final product = logic.product.value;
        if (product == null) return const Center(child: Text('Product not found.'));

        // Inject JSON-LD structured data
        final jsonLdScript = html.ScriptElement()
          ..type = 'application/ld+json'
          ..text = '''
            {
              "@context": "https://schema.org",
              "@type": "Product",
              "name": "${product.title}",
              "description": "${product.projectDesc}",
              "image": ${logic.imagesToShow.map((url) => '"$url"').toList()},
              "offers": {
                "@type": "Offer",
                "availability": "https://schema.org/InStock"
              }
            }
          ''';
        html.document.head!.append(jsonLdScript);

        return Seo.head(
          tags: [
            MetaTag(name: 'title', content: product.title ?? 'Project Details'),
            MetaTag(name: 'description', content: product.projectDesc ?? ''),
            LinkTag(rel: 'canonical', href: 'https://launchcode.shop/product-detail/${product.projectId}'),
            MetaTag(name: 'og:title', content: product.title ?? ''),
            MetaTag(name: 'og:description', content: product.projectDesc ?? ''),
            MetaTag(name: 'og:url', content: 'https://launchcode.shop/product-detail/${product.projectId}'),
            if (logic.imagesToShow.isNotEmpty)
              MetaTag(name: 'og:image', content: logic.imagesToShow.first),
            MetaTag(name: 'twitter:card', content: 'summary_large_image'),
          ],
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, logic),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildHeader(context, product),
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, 'description'),
                      const SizedBox(height: 8),
                      _buildDescription(context, product),
                      const SizedBox(height: 32),
                      if (product.demoAdminPanelLinks?.isNotEmpty ?? false)
                        ...product.demoAdminPanelLinks!.map((panel) => _buildShotBlockWithDemo(context, panel.name, panel.link, panel.shotUrls, logic)),
                      if (product.demoApkLinks?.isNotEmpty ?? false)
                        ...product.demoApkLinks!.map((apk) => _buildShotBlockWithDemo(context, apk.name, apk.link, apk.shotUrls, logic)),
                      if (product.mobileShotUrls?.isNotEmpty ?? false)
                        _buildShotBlockWithDemo(context, 'Overview Screenshots', null, product.mobileShotUrls, logic),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, Project product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(product.title ?? '', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => showDialog(context: context, builder: (ctx) => LaunchSteps()),
              child: Text("How to earn with this?".tr),
            ),
          ],
        ),
        if (product.subtitle?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(product.subtitle!, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
          ),
        const SizedBox(height: 12),
        if ((product.soldCount ?? 0) > 0)
          Text('Deployed: ${product.soldCount}', style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) => Row(
    children: [
      Container(width: 4, height: 24, color: _accentColor),
      const SizedBox(width: 8),
      Text(title.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    ],
  );

  Widget _buildDescription(BuildContext context, Project product) =>
      ReadMoreText(product.projectDesc ?? '', trimMode: TrimMode.Line, trimLines: 2, trimCollapsedText: 'Read More', trimExpandedText: 'Read Less', colorClickableText: Colors.black38);

  Widget _buildShotBlockWithDemo(BuildContext context, String? title, String? demoLink, List<String>? urls, ProjectDetailsLogic logic) {
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
                  future: TranslationService.translateText(title, Get.locale?.languageCode ?? 'en'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('...');
                    } else if (snapshot.hasError) {
                      return Text(title); // fallback to original
                    } else {
                      return Text(
                        snapshot.data ?? title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      );
                    }
                  },
                ),
                if (demoLink?.isNotEmpty ?? false)
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label:  Text('tryDemo'.tr),
                    onPressed: () => logic.launchUrlExternal(demoLink!),
                    style: TextButton.styleFrom(foregroundColor: _accentColor),
                  ),
              ],
            ),
          ),
        _buildImageList(context, urls, logic),
      ],
    );
  }

  Widget _buildImageList(BuildContext context, List<String> images, ProjectDetailsLogic logic) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () => _openImageViewer(context, images, i),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.hardEdge,
            child: Seo.image(
              src: images[i],
              alt: 'Screenshot ${i + 1} of ${logic.product.value?.title ?? 'product'}',
              child: Image.network(images[i], width: 150, height: 180, fit: BoxFit.cover),
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
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => Dialog(
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
                  cardBuilder: (ctx, i, _, __) => ClipRRect(
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
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
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
                            final focalPoint = MediaQuery.of(context).size.center(Offset.zero);
                            transformationController.value = Matrix4.identity()
                              ..translate(focalPoint.dx * (1 - scale), focalPoint.dy * (1 - scale))
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
                            icon: const Icon(Icons.arrow_drop_up, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                transformationController.value = transformationController.value
                                  ..translate(0.0, panDelta);
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Left
                              IconButton(
                                icon: const Icon(Icons.arrow_left, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    transformationController.value = transformationController.value
                                      ..translate(panDelta, 0.0);
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              // Right
                              IconButton(
                                icon: const Icon(Icons.arrow_right, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    transformationController.value = transformationController.value
                                      ..translate(-panDelta, 0.0);
                                  });
                                },
                              ),
                            ],
                          ),
                          // Down
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                transformationController.value = transformationController.value
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
                            final focalPoint = MediaQuery.of(context).size.center(Offset.zero);
                            transformationController.value = Matrix4.identity()
                              ..translate(focalPoint.dx * (1 - scale), focalPoint.dy * (1 - scale))
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

  Widget _buildSliverAppBar(BuildContext context, ProjectDetailsLogic logic) {
    final product = logic.product.value;

    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      expandedHeight: 120,
      elevation: 4,
      iconTheme: const IconThemeData(color: Colors.black87),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: CircleAvatar(
          backgroundColor: Colors.black12,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              } else {
                // No previous screen → restart app or go to home
                // Option 1: Hard reload (only for Flutter Web)
                // import 'dart:html' as html; already imported
                html.window.location.href = '/';
              }
            },
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        product?.title ?? '',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: const FlexibleSpaceBar(
        background: SizedBox(), // no image
      ),
    );
  }

}
