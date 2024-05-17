import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/features/shop/controllers/banner_controller.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';

class UploadBanners extends StatelessWidget {
  const UploadBanners({super.key});

  @override
  Widget build(BuildContext context) {
    final contoller = Get.put(BannerController());
    return Scaffold(
        appBar: TAppBar(
            showBackArrow: true,
            title: Text('Upload Banners',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .apply(color: TColors.white))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //name
                Column(
                  children: [
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: contoller.bannerImage,
                      validator: (value) =>
                          TValidator.validateEmptyText('Banner Image', value),
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: TTexts.uploadImage,
                          prefixIcon: Icon(Iconsax.user_edit)),
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Obx(
                            () => Checkbox(
                                value: contoller.active.value,
                                onChanged: (value) => contoller.active.value =
                                    !contoller.active.value),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Text('Active ?',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    ///Sign Up Button
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => contoller.addBanner(),
                            // onPressed: () => controller.signup(),
                            child: const Text(TTexts.upload)))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
