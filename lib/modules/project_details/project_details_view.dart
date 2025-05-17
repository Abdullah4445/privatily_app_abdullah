// Redesigned ProjectDetailsPage with SEO-safe meta and injected JSON-LD manually via dart:html

import 'package:web/web.dart' as web;

import 'dart:html' as html;

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:seo/seo.dart';

import '../../models/products.dart';
import '../../widgets/myProgressIndicator.dart';
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

        // Inject JSON-LD structured data into head manually
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
            LinkTag(
              rel: 'canonical',
              href: 'https://launchcode.shop/product-detail/${product.projectId}',
            ),
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
                      _buildSectionTitle(context, 'Description'),
                      const SizedBox(height: 8),
                      _buildDescription(context, product),
                      const SizedBox(height: 32),
                      if (product.demoAdminPanelLinks?.isNotEmpty ?? false) ...[
                        _buildSectionTitle(context, 'Admin Panels'),
                        ...product.demoAdminPanelLinks!.map(
                              (panel) => _buildShotBlockWithDemo(context, panel.name, panel.link, panel.shotUrls, logic),
                        ),
                      ],
                      if (product.demoApkLinks?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 32),
                        _buildSectionTitle(context, 'Mobile Apps'),
                        ...product.demoApkLinks!.map(
                              (apk) => _buildShotBlockWithDemo(context, apk.name, apk.link, apk.shotUrls, logic),
                        ),
                      ],
                      if (product.mobileShotUrls?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 32),
                        _buildSectionTitle(context, 'Overview Screenshots'),
                        _buildImageList(context, product.mobileShotUrls!, logic),
                      ],
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
        Text(product.title ?? '', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        if (product.subtitle?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(product.subtitle!, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            if ((product.soldCount ?? 0) > 0)
              Text('Deployed: ${product.soldCount}', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(width: 4, height: 24, color: _accentColor),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

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
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                if (demoLink?.isNotEmpty ?? false)
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Try Demo'),
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
    int currentIndex = initialIndex;

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
              CardSwiper(
                controller: swiperController,
                cardsCount: images.length,
                initialIndex: initialIndex,
                onSwipe: (previousIndex, newIndex, direction) {
                  setState(() => currentIndex = newIndex!);
                  return true;
                },
                cardBuilder: (context, index, percentX, percentY) => Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(images[index], fit: BoxFit.contain),
                  ),
                ),
              ),
              Positioned(
                top: 32,
                left: 16,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              if (currentIndex > 0)
                Positioned(
                  left: 16,
                  top: MediaQuery.of(context).size.height / 2 - 24,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () {
                        swiperController.swipe(CardSwiperDirection.left);
                        setState(() => currentIndex--);
                      },
                    ),
                  ),
                ),
              if (currentIndex < images.length - 1)
                Positioned(
                  right: 16,
                  top: MediaQuery.of(context).size.height / 2 - 24,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onPressed: () {
                        swiperController.swipe(CardSwiperDirection.right);
                        setState(() => currentIndex++);
                      },
                    ),
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
      expandedHeight: 320,
      iconTheme: const IconThemeData(color: Colors.black87),
      title: Text(product?.title ?? '', style: const TextStyle(color: Colors.black87)),
      flexibleSpace: FlexibleSpaceBar(
        background: product == null
            ? Container()
            : CarouselSlider.builder(
          itemCount: logic.imagesToShow.length,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 16 / 9,
          ),
          itemBuilder: (context, index, realIndex) {
            final imgUrl = logic.imagesToShow[index];
            return Seo.image(
              src: imgUrl,
              alt: 'Main image ${index + 1} of ${product.title}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imgUrl, fit: BoxFit.cover, width: double.infinity),
              ),
            );
          },
        ),
      ),
    );
  }
}
