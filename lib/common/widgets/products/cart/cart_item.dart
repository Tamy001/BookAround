import 'package:flutter/material.dart';

import '../../../../features/shop/models/cart_item_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../images/t_rounded_image.dart';
import '../../texts/product_title_text.dart';
import '../../texts/t_brand_title_text_with_vertical_icon.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({
    super.key,
    required this.cartItem,
  });

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ///Image
        TRoundedImage(
          imageUrl: cartItem.image ?? '',
          isNetworkImage: true,
          fit: BoxFit.contain,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(TSizes.xs),
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),

        ///Title, Price & BookCover Type
        Expanded(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TProductTitleText(
                  title: (cartItem.title),
                ),
                const SizedBox(
                  height: TSizes.sm,
                ),
                TBrandTitleWithVerifiedIcon(
                  title: cartItem.brandName ?? '',
                  maxLines: 1,
                ),

                ///Attributes
                Text.rich(TextSpan(
                    children: (cartItem.selectedVariation ?? {})
                        .entries
                        .map((e) => TextSpan(children: [
                              TextSpan(
                                  text: ' ${e.key} ',
                                  style: Theme.of(context).textTheme.bodySmall),
                              TextSpan(
                                  text: ' ${e.value} ',
                                  style: Theme.of(context).textTheme.bodySmall)
                            ]))
                        .toList())),
              ]),
        ),
      ],
    );
  }
}
