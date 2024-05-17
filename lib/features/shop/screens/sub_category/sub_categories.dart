import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/images/t_circular_image.dart';
import 'package:t_store/common/widgets/images/t_rounded_image.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/models/category_model.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';

import '../../../../common/widgets/products/product_cards/product_card_horizontal.dart';
import '../../../../common/widgets/shimmers/horizontal_product_shimmer.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/category_controller.dart';
import '../all_product/all_products.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        title: Text(category.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const TRoundedImage(
                  width: double.infinity,
                  imageUrl: TImages.promoBanner2,
                  applyImageRadius: true),
              const SizedBox(height: TSizes.spaceBtwSections),
              FutureBuilder(
                  future: controller.getSubCategories(category.id),
                  builder: (context, snapshot) {
                    const loader = THorizontalProductShimmer();
                    final widget = TCloudHelperFunctions.checkMultiRecordState(
                        snapshot: snapshot, loader: loader);
                    if (widget != null) return widget;

                    // record found
                    final subCategories = snapshot.data!;
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: subCategories.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          final subCategory = subCategories[index];
                          return FutureBuilder(
                              future: controller.getCategoryProducts(
                                  categoryId: subCategory.id),
                              builder: (context, snapshot) {
                                final widget =
                                    TCloudHelperFunctions.checkMultiRecordState(
                                        snapshot: snapshot, loader: loader);
                                if (widget != null) return widget;

                                // record found
                                final products = snapshot.data!;
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        TCircularImage(
                                            image: subCategory.image,
                                            isNetworkImage: true,
                                            overlayColor: dark
                                                ? TColors.light
                                                : TColors.dark),
                                        TSectionHeading(
                                          title: subCategory.name,
                                          onPressed: () =>
                                              Get.to(() => AllProducts(
                                                    title: subCategory.name,
                                                    futureMethod: controller
                                                        .getCategoryProducts(
                                                            categoryId:
                                                                subCategory.id,
                                                            limit: -1),
                                                  )),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: TSizes.spaceBtwSections / 2),
                                    SizedBox(
                                      height: 120,
                                      child: ListView.separated(
                                        itemBuilder: (context, index) =>
                                            TProductCardHorizontal(
                                                product: products[index]),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                                width: TSizes.spaceBtwItems),
                                        itemCount: products.length,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
