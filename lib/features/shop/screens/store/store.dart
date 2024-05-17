import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/brands/brands_card.dart';
import 'package:t_store/common/widgets/custom_shapes/container/search_container.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/controllers/category_controller.dart';
import 'package:t_store/features/shop/controllers/product/brand_controller.dart';
import 'package:t_store/features/shop/screens/brand/all_brand.dart';
import 'package:t_store/features/shop/screens/brand/brand_products.dart';
import 'package:t_store/features/shop/screens/home/widgets/search_page.dart';

import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/appbar/tabbar.dart';
import '../../../../../../utils/constants/colors.dart';

import '../../../../common/widgets/shimmers/brands_shimmer.dart';
import 'widgets/category_tab.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final categories = CategoryController.instance.featuredCategories;
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            'Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: const [TCartCounterIcon()],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.black
                    : TColors.white,
                expandedHeight: 500,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: TSizes.spaceBtwItems),
                      TSearchContainer(
                          text: 'Search in Store',
                          onTap: () => Get.to(TSearchPage),
                          showBorder: true,
                          showBackground: false,
                          padding: EdgeInsets.zero),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      ///--Featured Authors/Brands
                      TSectionHeading(
                        title: 'Featured Authors',
                        showActionButton: true,
                        onPressed: () => Get.to(const AllBrandsScreen()),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 1.5),

                      Obx(() {
                        if (brandController.isLoading.value) {
                          return const TBrandsShimmer();
                        }

                        if (brandController.featuredBrands.isEmpty) {
                          return Center(
                            child: Text(
                              'No Data Found',
                              style: Theme.of(context).textTheme.bodyMedium!,
                            ),
                          );
                        }
                        return TGridLayout(
                            itemCount: brandController.featuredBrands.length,
                            mainAxisExtent: 80,
                            itemBuilder: (_, index) {
                              final brand =
                                  brandController.featuredBrands[index];
                              return TBrandCard(
                                showBorder: true,
                                brand: brand,
                                onTap: () => Get.to(() => BrandProducts(
                                      brand: brand,
                                    )),
                              );
                            });
                      })
                    ],
                  ),
                ),
                bottom: TTabBar(
                    tabs: categories
                        .map((category) => Tab(child: Text(category.name)))
                        .toList()),
              ),
            ];
          },

          ///Brands
          body: TabBarView(
              children: categories
                  .map((category) => TCategoryTab(category: category))
                  .toList()),
        ),
      ),
    );
  }
}
