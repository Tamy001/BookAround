import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/personalization/screens/upload/product_types/upload_single_product.dart';
import 'package:t_store/features/personalization/screens/upload/product_types/upload_var_color.dart';
import 'package:t_store/features/personalization/screens/upload/product_types/upload_var_cover.dart';
import 'package:t_store/utils/constants/colors.dart';
import '../../../../common/list_tile/settings_menu_title.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/container/primary_header_container.dart';
import '../../../../utils/constants/sizes.dart';

class UploadProducts extends StatelessWidget {
  const UploadProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
                child: Column(
              children: [
                ///AppBar
                TAppBar(
                  title: Text('Product Types',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white)),
                  showBackArrow: true,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(children: [
                TSettingsMenuTile(
                  icon: Iconsax.document_upload,
                  title: 'No Variations',
                  subTitle: 'Upload Single Type',
                  onTap: () => Get.to(() => const UploadSingleProducts()),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.document_upload,
                  title: 'With Cover-Color Variations',
                  subTitle: 'Different Cover-Colors',
                  onTap: () => Get.to(() => const UploadColorProducts()),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.document_upload,
                  title: 'With Cover-Type Variations',
                  subTitle: 'Different Cover-Types',
                  onTap: () => Get.to(() => const UploadCoverProducts()),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
