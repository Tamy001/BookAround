import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:t_store/common/widgets/custom_shapes/container/search_container.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/screens/all_product/all_products.dart';
import 'package:t_store/features/shop/screens/home/widgets/search_page.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';

import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../controllers/product/product_controller.dart';
import 'widgets/home_appbar.dart';
import 'widgets/home_categories.dart';
import 'widgets/promo_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(children: [
                /// Appbar
                const THomeAppBar(),

                const SizedBox(height: TSizes.spaceBtwSections),

                /// Searchbar
                TSearchContainer(
                  text: 'Search in store',
                  onTap: () => Get.to(const TSearchPage()),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// Categories
                const Padding(
                  padding: EdgeInsets.only(left: TSizes.defaultSpace),
                  child: Column(
                    children: [
                      ///Heading
                      TSectionHeading(
                        title: 'Popular Categories',
                        showActionButton: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(height: TSizes.spaceBtwItems),

                      //Scroller
                      THomeCategories()
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ]),
            ),

            ///Carousel Slider
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(children: [
                const TPromoSlider(
                  banners: [
                    TImages.promoBanner1,
                    TImages.promoBanner2,
                    TImages.promoBanner3
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TSectionHeading(
                  title: 'Popular Books',
                  onPressed: () => Get.to(() => AllProducts(
                        title: 'All Books',
                        futureMethod: controller.fetchAllProducts(),
                      )),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const SizedBox(height: TSizes.spaceBtwItems),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const TVerticalProductShimmer();
                  }

                  if (controller.featuredProducts.isEmpty) {
                    return Center(
                        child: Text(
                      'No products found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ));
                  }
                  return TGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_, index) => TProductCardVertical(
                            product: controller.featuredProducts[index],
                          ));
                })
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
