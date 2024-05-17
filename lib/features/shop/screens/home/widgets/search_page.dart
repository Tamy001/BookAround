import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:t_store/features/shop/controllers/product/all_products_controller.dart';
import 'package:t_store/features/shop/models/product_model.dart';

import '../../../../../common/widgets/appbar/appbar.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class TSearchPage extends StatelessWidget {
  const TSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    final TextEditingController searchController = TextEditingController();
    Future<List<ProductModel>> productL = Future.value([]);

    return Scaffold(
        appBar: TAppBar(
            showBackArrow: true,
            title: Text('Search Items',
                style: Theme.of(context).textTheme.headlineMedium!)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //name
                Column(children: [
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: searchController,
                    onChanged: (query) {
                      controller.searchProducts(query);
                      productL = controller.searchProducts(query);
                    },
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: TTexts.search,
                        prefixIcon: Icon(Iconsax.search_normal)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Product Grid
                  Obx(
                    () => TGridLayout(
                      itemCount: controller.products.length,
                      itemBuilder: (_, index) => TProductCardVertical(
                        product: controller.products[index],
                      ),
                    ),
                  ),
                ])
              ],
            ),
          ),
        ));
  }
}
