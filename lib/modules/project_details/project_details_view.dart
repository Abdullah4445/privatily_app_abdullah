import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/products.dart';
import 'project_details_logic.dart';

class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({Key? key}) : super(key: key);

  // var routeName = '/PojectDetailPage';

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ProjectDetailsLogic());  // Get the controller using Get.find()

    return Scaffold(
      body: Obx(() {
        if (!logic.isProductLoaded || logic.product.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = logic.product.value!;

        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(context, logic),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfo(context, product),
                    _buildActionButtons(context, logic),
                    _buildDescription(context, product),
                    if (product.shotUrls?.isNotEmpty ?? false) _buildScreenshotsGallery(context, product),
                    if (_hasDemos(product)) _buildDemoLinks(context, logic, product),
                    _buildOtherDetails(context, product),
                  ],
                ),
              ),
            ),
          ],
        );
      }),

    );
  }

  bool _hasDemos(Project product) {
    return (product.demoAdminPanelLinks?.isNotEmpty ?? false) ||
        (product.demoApkLinks?.isNotEmpty ?? false) ||
        (product.demoVideoUrl?.isNotEmpty ?? false);
  }

  Widget _buildSliverAppBar(BuildContext context, ProjectDetailsLogic logic) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(logic.product.value?.title ?? 'Product Details'),
        background: _buildImageCarousel(logic),
      ),
    );
  }

  Widget _buildImageCarousel(ProjectDetailsLogic logic) {
    return Obx(() {
      final images = logic.imagesToShow;
      return CarouselSlider.builder(
        itemCount: images.length,
        itemBuilder: (context, index, realIdx) {
          return Image.network(images[index], fit: BoxFit.cover);
        },
        options: CarouselOptions(
          height: 350.0,
          viewportFraction: 1.0,
          onPageChanged: (index, reason) => logic.updateImageIndex(index),
        ),
      );
    });
  }

  Widget _buildBasicInfo(BuildContext context, Project product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.title ?? 'No Title', style: Theme.of(context).textTheme.titleLarge),
        if (product.subtitle?.isNotEmpty ?? false) ...[
          Text(product.subtitle!, style: Theme.of(context).textTheme.titleMedium),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${product.price}', style: Theme.of(context).textTheme.titleLarge),
            if (product.soldCount != null) Text('Sold: ${product.soldCount}'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ProjectDetailsLogic logic) {
    return Row(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.add_shopping_cart_outlined),
          label: const Text('Add to Cart'),
          onPressed: logic.addToCart,
        ),
        if (logic.product.value?.projectLink != null)
          OutlinedButton.icon(
            icon: const Icon(Icons.visibility_outlined),
            label: const Text('Preview'),
            onPressed: () => logic.launchUrlExternal(logic.product.value!.projectLink),
          ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, Project product) {
    return Text(product.projectDesc ?? 'No description available.');
  }

  Widget _buildScreenshotsGallery(BuildContext context, Project product) {
    final screenshots = product.shotUrls?.where((url) => url != product.thumbnailUrl).toList() ?? [];
    if (screenshots.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: screenshots.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Update image carousel on thumbnail tap
            },
            child: Image.network(screenshots[index], width: 150, height: 150, fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _buildDemoLinks(BuildContext context, ProjectDetailsLogic logic, Project product) {
    return Column(
      children: [
        if (product.demoAdminPanelLinks?.isNotEmpty ?? false)
          ...product.demoAdminPanelLinks!.map((link) => _buildLinkTile(context, logic, link.url)),
        if (product.demoApkLinks?.isNotEmpty ?? false)
          ...product.demoApkLinks!.map((link) => _buildLinkTile(context, logic, link.url)),
        if (product.demoVideoUrl?.isNotEmpty ?? false)
          _buildLinkTile(context, logic, product.demoVideoUrl??''),
      ],
    );
  }

  Widget _buildLinkTile(BuildContext context, ProjectDetailsLogic logic, String? link) {
    return ListTile(
      leading: const Icon(Icons.launch),
      title: Text('Demo Link'),
      onTap: () => logic.launchUrlExternal(link),
    );
  }

  Widget _buildOtherDetails(BuildContext context, Project product) {
    return Column(
      children: [
        _buildDetailRow('Customization', product.isCustomizationAvailable! ? 'Available' : 'Not Available'),
        _buildDetailRow('Created At', product.createdAt?.toString() ?? 'Unknown'),
        _buildDetailRow('Project ID', product.projectId ?? 'N/A'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }
}
