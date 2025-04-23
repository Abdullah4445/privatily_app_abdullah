import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seo/seo.dart'; // SEO package for head tags and semantic markup

import '../../models/products.dart';
import '../../widgets/myProgressIndicator.dart';
import 'project_details_logic.dart';

class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({super.key});

  static const _horizontalPadding = 16.0;
  static const _accentColor = Color(0xFF00E676);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ProjectDetailsLogic());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (!logic.isProductLoaded) {
          return const Center(child: MyLoader());
        }
        final product = logic.product.value;
        if (product == null) {
          return const Center(child: Text('Product not found.'));
        }

        // Inject dynamic SEO head tags for each product
        return Seo.head(
          tags: [
            MetaTag(name: 'description', content: product.projectDesc ?? ''),
            LinkTag(
              rel: 'canonical',
              href: 'https://launchcode.shop/product-detail/${product.projectId}',
            ),
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

                      // Product title as SEO-enhanced h1
                      Seo.text(
                        text: product.title ?? '',
                        style: TextTagStyle.h1,
                        child: Text(
                          product.title ?? '',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      if (product.subtitle?.isNotEmpty ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Seo.text(
                            text: product.subtitle!,
                            style: TextTagStyle.h2,
                            child: Text(
                              product.subtitle!,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 16),
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Seo.text(
                              text: '\$${product.price?.toStringAsFixed(2) ?? 'N/A'}',
                              style: TextTagStyle.h2,
                              child: Text(
                                '\$${product.price?.toStringAsFixed(2) ?? 'N/A'}',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  color: _accentColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          if ((product.soldCount ?? 0) > 0)
                            Seo.text(
                              text: 'Sold: ${product.soldCount}',
                              style: TextTagStyle.p,
                              child: Text(
                                'Sold: ${product.soldCount}',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Action buttons remain unchanged
                      _buildActionButtons(context, logic),

                      const SizedBox(height: 32),

                      // Section heading and description
                      _buildSectionTitle(context, 'Description', isSeo: true),
                      const SizedBox(height: 8),
                      _buildDescription(context, product, isSeo: true),

                      // Gallery sections with SEO-wrapped section titles
                      if (product.adminPanelScreenshots.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        _buildGallerySection(
                          context,
                          title: 'Admin Panel Screenshots',
                          images: product.adminPanelScreenshots,
                          logic: logic,
                          isSeo: true,
                        ),
                      ],

                      if (product.apkDemoScreenshots.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        _buildGallerySection(
                          context,
                          title: 'APK Demo Screenshots',
                          images: product.apkDemoScreenshots,
                          logic: logic,
                          isSeo: true,
                        ),
                      ],

                      if (_hasDemos(product)) ...[
                        const SizedBox(height: 32),
                        _buildSectionTitle(context, 'Live Demos', isSeo: true),
                        _buildDemoLinks(context, logic, product),
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

  Widget _buildActionButtons(BuildContext c, ProjectDetailsLogic logic) {
    final link = logic.product.value?.projectLink;
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text('Add to Cart'),
          onPressed: logic.addToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            elevation: 6,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        if (link?.isNotEmpty ?? false)
          OutlinedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Preview'),
            onPressed: () => logic.launchUrlExternal(link),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: _accentColor, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
            ),
          ),
      ],
    );
  }

  /// Section title builder now supports wrapping in SEO.text
  Widget _buildSectionTitle(BuildContext c, String text, {bool isSeo = false}) {
    final row = Row(
      children: [
        Container(width: 4, height: 24, color: _accentColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme
              .of(c)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
    if (isSeo) {
      return Seo.text(
        text: text,
        style: TextTagStyle.h2,
        child: row,
      );
    }
    return row;
  }

  /// Description builder with optional SEO wrapping
  Widget _buildDescription(BuildContext c, Project p, {bool isSeo = false}) {
    final desc = Text(
      p.projectDesc ?? '',
      style: Theme
          .of(c)
          .textTheme
          .bodyMedium
          ?.copyWith(height: 1.6, color: Colors.grey[800]),
    );
    if (isSeo) {
      return Seo.text(
        text: p.projectDesc ?? '',
        style: TextTagStyle.p,
        child: desc,
      );
    }
    return desc;
  }

  /// Gallery section with SEO-wrapped heading
  Widget _buildGallerySection(BuildContext c, {
    required String title,
    required List<String> images,
    required ProjectDetailsLogic logic,
    bool isSeo = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isSeo) ...[
          _buildSectionTitle(c, title, isSeo: true),
        ] else
          ...[
            _buildSectionTitle(c, title),
          ],
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (ctx, i) {
              return GestureDetector(
                onTap: () => _openImageViewer(c, images, i),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.hardEdge,
                  child: Seo.image(
                    src: images[i],
                    alt: 'Screenshot ${i + 1} of $title',
                    child: Image.network(
                      images[i],
                      width: 150,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openImageViewer(BuildContext context,
      List<String> images,
      int initialIndex,) {
    final controller = CarouselSliderController();
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) =>
          Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CarouselSlider.builder(
                  controller: controller,
                  itemCount: images.length,
                  itemBuilder: (ctx, idx, realIdx) =>
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: InteractiveViewer(
                          child: Seo.image(
                            src: images[idx],
                            alt: 'Full-screen screenshot',
                            child: Center(
                              child: Image.network(
                                images[idx],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                  options: CarouselOptions(
                    initialPage: initialIndex,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.9,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  bool _hasDemos(Project p) {
    return p.demoAdminPanelLinks!.isNotEmpty ||
        p.demoApkLinks!.isNotEmpty ||
        (p.demoVideoUrl?.isNotEmpty ?? false);
  }

  Widget _buildDemoLinks(BuildContext c,
      ProjectDetailsLogic logic,
      Project p,) {
    return Column(
      children: [
        for (final d in [
          ...p.demoAdminPanelLinks!.map((e) => MapEntry(e.name ?? 'Admin Demo', e.link)),
          ...p.demoApkLinks!.map((e) => MapEntry(e.name ?? 'APK Demo', e.link)),
          if (p.demoVideoUrl?.isNotEmpty ?? false) MapEntry('Video Demo', p.demoVideoUrl!)
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                leading: Icon(
                  d.key.contains('Video') ? Icons.play_circle_rounded : Icons.link,
                  color: _accentColor,
                ),
                title: Seo.link(
                  href: d.value.toString(),
                  anchor: d.key,
                  child: Text(d.key),
                ),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => logic.launchUrlExternal(d.value),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ProjectDetailsLogic logic) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Seo.text(
          text: logic.product.value?.title ?? '',
          style: TextTagStyle.h3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              logic.product.value?.title ?? '',
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        background: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Obx(() {
                final images = logic.imagesToShow;
                return CarouselSlider.builder(
                  itemCount: images.length,
                  itemBuilder: (ctx, idx, realIdx) =>
                      Seo.image(
                        src: images[idx],
                        alt: 'Carousel image ${idx + 1}',
                        child: Image.network(
                          images[idx],
                          fit: BoxFit.cover,
                          loadingBuilder: (ctx, w, prog) =>
                          prog == null ? w : const Center(child: MyLoader()),
                        ),
                      ),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    autoPlay: images.length > 1,
                    onPageChanged: (i, _) => logic.updateImageIndex(i),
                  ),
                );
              }),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.white54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
    );
  }
}
