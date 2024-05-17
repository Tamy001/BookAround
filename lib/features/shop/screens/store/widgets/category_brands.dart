import 'package:flutter/material.dart';
import 'package:t_store/common/widgets/brands/brands_show_case.dart';
import 'package:t_store/features/shop/models/category_model.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';

import '../../../../../common/widgets/shimmers/boxes_shimmer.dart';
import '../../../../../common/widgets/shimmers/list_tile_shimmer.dart';
import '../../../controllers/product/brand_controller.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return FutureBuilder(
        future: controller.getBrandsForCategory(category.id),
        builder: (context, snapshot) {
          //Handling Loader, No record or error message
          const loader = Column(
            children: [
              TListTileShimmer(),
              SizedBox(height: TSizes.spaceBtwItems),
              TBoxesShimmer(),
              SizedBox(height: TSizes.spaceBtwItems)
            ],
          );
          final widget = TCloudHelperFunctions.checkMultiRecordState(
              snapshot: snapshot, loader: loader);
          if (widget != null) return widget;

          //Brand Found!
          final brands = snapshot.data!;

          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: brands.length,
              itemBuilder: (_, index) {
                final brand = brands[index];
                return FutureBuilder(
                    future: controller.getBrandProducts(
                        brandId: brand.id, limit: 3),
                    builder: (context, snapshot) {
                      //Handling Loader, No record or error message
                      final widget =
                          TCloudHelperFunctions.checkMultiRecordState(
                              snapshot: snapshot, loader: loader);
                      if (widget != null) return widget;

                      //Product Record Found
                      final products = snapshot.data!;

                      return TBrandShowcase(
                          images: products.map((e) => e.thumbnail).toList(),
                          brand: brand);
                    });
              });
        });
  }
}
