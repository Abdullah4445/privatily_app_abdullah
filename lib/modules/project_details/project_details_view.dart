// Redesigned ProjectDetailsPage with demo links beside each screenshot group

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seo/seo.dart';

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
        if (!logic.isProductLoaded) return const Center(child: MyLoader());
        final product = logic.product.value;
        if (product == null) return const Center(child: Text('Product not found.'));

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
                      _buildHeader(context, product),
                      const SizedBox(height: 24),
                      _buildActionButtons(context, logic),
                      const SizedBox(height: 32),
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
                        _buildImageList(context, product.mobileShotUrls!),
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
        Text(
          product.title ?? '',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (product.subtitle?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              product.subtitle!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(width: 4, height: 24, color: _accentColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, Project product) => Text(
    product.projectDesc ?? '',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6, color: Colors.grey[800]),
  );

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
        _buildImageList(context, urls),
      ],
    );
  }

  Widget _buildImageList(BuildContext context, List<String> images) {
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
            child: Image.network(
              images[i],
              width: 150,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  void _openImageViewer(BuildContext context, List<String> images, int initialIndex) {
    final controller = CarouselSliderController();
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider.builder(
              controller: controller,
              itemCount: images.length,
              itemBuilder: (ctx, idx, realIdx) => GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: InteractiveViewer(
                  child: Center(
                    child: Image.network(
                      images[idx],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              options: CarouselOptions(
                initialPage: initialIndex,
                height: MediaQuery.of(context).size.height * 0.9,
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

  bool _hasDemos(Project p) =>
      (p.demoAdminPanelLinks?.isNotEmpty ?? false) ||
          (p.demoApkLinks?.isNotEmpty ?? false) ||
          (p.demoVideoUrl?.isNotEmpty ?? false);

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
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
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
                  itemBuilder: (ctx, idx, realIdx) => Seo.image(
                    src: images[idx],
                    alt: 'Carousel image ${idx + 1}',
                    child: Image.network(
                      images[idx],
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, w, prog) => prog == null ? w : const Center(child: MyLoader()),
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
