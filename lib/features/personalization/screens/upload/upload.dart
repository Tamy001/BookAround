import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/personalization/screens/upload/upload_banners.dart';
import 'package:t_store/features/personalization/screens/upload/upload_brands.dart';
import 'package:t_store/features/personalization/screens/upload/upload_categories.dart';
import 'package:t_store/features/personalization/screens/upload/upload_products.dart';

import '../../../../common/list_tile/settings_menu_title.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/container/primary_header_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

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
                  title: Text('Upload Files',
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
                ///Account Settings
                // const TSectionHeading(
                //     title: 'Idk', showActionButton: false),
                // const SizedBox(height: TSizes.spaceBtwItems),
                TSettingsMenuTile(
                  icon: Iconsax.document_upload,
                  title: 'Upload Genres',
                  subTitle: 'Add new genres',
                  onTap: () => Get.to(() => const UploadCategories()),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.document_upload,
                  title: 'Upload Authors',
                  subTitle: 'Register new author/company',
                  onTap: () => Get.to(() => const UploadBrands()),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.document_upload,
                  title: 'Upload Banners',
                  subTitle: 'Add new banners',
                  onTap: () => Get.to(() => const UploadBanners()),
                  // onTap: () => Get.to(() => const OrderScreen()),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.document_upload,
                  title: 'Upload Products',
                  subTitle: 'Add new banners',
                  onTap: () => Get.to(() => const UploadProducts()),
                  // onTap: () => Get.to(() => const OrderScreen()),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
