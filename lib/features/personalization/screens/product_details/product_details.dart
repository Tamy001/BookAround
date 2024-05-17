import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/personalization/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:t_store/features/personalization/screens/product_details/widgets/product_attributes.dart';
import 'package:t_store/features/personalization/screens/product_details/widgets/product_meta_data.dart';
import 'package:t_store/features/shop/screens/cart/cart.dart';
import 'package:t_store/utils/constants/enums.dart';

import 'package:t_store/utils/constants/sizes.dart';

import '../../../shop/controllers/product/variation_controller.dart';
import '../../../shop/models/product_model.dart';
import '../../../shop/screens/product_reviews/product_reviews.dart';
import 'widgets/product_detail_image_slider.dart';
import 'widgets/rating_share_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = VariationController.instance;
    controller.resetSelectedAttributes();
    return Scaffold(
      bottomNavigationBar: TBottomAddToCart(product: product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Product Image Slider
            TProductImageSlider(product: product),

            ///Product Details
            Padding(
              padding: const EdgeInsets.only(
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  ///Rating & Share Button
                  const TRatingAndShare(),

                  ///Price, Title,Stack & Brand
                  TProductMetaData(product: product),

                  ///Attributes
                  if (product.productType == ProductType.variable.toString())
                    TProductAttributes(product: product),
                  if (product.productType == ProductType.variable.toString())
                    const SizedBox(height: TSizes.spaceBtwSections),

                  ///Checkout Button
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () => Get.to(const CartScreen()),
                          child: const Text('Checkout'))),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  ///Description
                  const TSectionHeading(
                      title: 'Description', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  ///Reviews
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TSectionHeading(
                          title: 'Reviews(28)',
                          onPressed: () {},
                          showActionButton: false,
                        ),
                        IconButton(
                            onPressed: () =>
                                Get.to(() => const ProductReviewsSceen()),
                            icon: const Icon(Iconsax.arrow_right_3, size: 18))
                      ]),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
