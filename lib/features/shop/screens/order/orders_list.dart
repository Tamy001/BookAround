import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:t_store/common/widgets/loaders/animation_loader.dart';
import 'package:t_store/features/shop/controllers/product/order_controller.dart';
import 'package:t_store/features/shop/screens/store/store.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    final dark = THelperFunctions.isDarkMode(context);
    return FutureBuilder(
        future: controller.fetchUserOrders(),
        builder: (_, snapshot) {
          //nOTHING Found Widget
          final emptyWidget = TAnimationLoaderWidget(
            text: 'Whoops no orders yet!',
            animation: TImages.emptyWishlist,
            showAction: true,
            actionText: 'Let\'s fill it',
            onActionPressed: () => Get.to(const StoreScreen()),
          );

          //Helper function to handle loader, no record or error message
          final response = TCloudHelperFunctions.checkMultiRecordState(
              snapshot: snapshot, nothingFound: emptyWidget);
          if (response != null) return response;

          //Record found
          final orders = snapshot.data!;
          return ListView.separated(
              shrinkWrap: true,
              itemCount: orders.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: TSizes.spaceBtwItems),
              itemBuilder: (_, index) {
                final order = orders[index];
                return TRoundedContainer(
                  showBorder: true,
                  padding: const EdgeInsets.all(TSizes.md),
                  backgroundColor: dark ? TColors.dark : TColors.light,
                  child: Column(children: [
                    ///ROW 1
                    Row(
                      children: [
                        const Icon(Iconsax.ship),
                        const SizedBox(width: TSizes.spaceBtwItems / 2),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderStatusText,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(
                                        color: TColors.primary,
                                        fontWeightDelta: 1),
                              ),
                              Text(order.formattedOrderDate,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall)
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Iconsax.arrow_right_34,
                              size: TSizes.iconSm,
                            ))
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    ///ROW 2
                    Row(children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.tag),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  Text(order.id,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.calendar),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Shipping Date',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  Text(order.formattedDeliveryDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ]),
                );
              });
        });
  }
}
