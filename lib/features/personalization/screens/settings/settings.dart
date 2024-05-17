import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/list_tile/settings_menu_title.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store/features/personalization/screens/address/address.dart';
import 'package:t_store/features/personalization/screens/chatbot/chatbot.dart';
import 'package:t_store/features/personalization/screens/upload/upload.dart';
import 'package:t_store/features/shop/screens/cart/cart.dart';
import 'package:t_store/features/shop/screens/order/widgets/order.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';

import '../../../../common/list_tile/user_profile_tile.dart';
import '../profile/profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationRepository());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
                child: Column(
              children: [
                ///AppBar
                TAppBar(
                    title: Text('Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .apply(color: TColors.white))),
                const SizedBox(height: TSizes.spaceBtwSections),

                ///User Profile Screen
                TUserProfileTile(
                    onPressed: () => Get.to(() => const ProfileScreen())),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(children: [
                ///Account Settings
                const TSectionHeading(
                    title: 'Account Settings', showActionButton: false),
                const SizedBox(height: TSizes.spaceBtwItems),
                TSettingsMenuTile(
                  icon: Iconsax.safe_home,
                  title: 'My addresses',
                  subTitle: 'Set shoppng delivary address',
                  onTap: () => Get.to(() => const UserAddressScreen()),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.shopping_cart,
                  title: 'My cart',
                  subTitle: 'Add/remove products & move to checkout',
                  onTap: () => Get.to(() => const CartScreen()),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.bag_tick,
                  title: 'My Orders',
                  subTitle: 'In-progress & completed orders',
                  onTap: () => Get.to(() => const OrderScreen()),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.bank,
                  title: 'Bank Account',
                  subTitle: 'Withdraw balance to registered bank account',
                  onTap: () {},
                ),
                TSettingsMenuTile(
                    icon: Iconsax.support,
                    title: 'Chat Bot',
                    subTitle: 'Ask any question',
                    onTap: () => Get.to(() => const ChatPage())),
                TSettingsMenuTile(
                  icon: Iconsax.notification,
                  title: 'Notifications',
                  subTitle: 'Set any kind of notification message',
                  onTap: () {},
                ),
                TSettingsMenuTile(
                  icon: Iconsax.security_card,
                  title: 'Account Privacy',
                  subTitle: 'Set shoppng delivary address',
                  onTap: () {},
                ),

                ///App Settings
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                const TSectionHeading(
                    title: 'App Settings', showActionButton: false),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                TSettingsMenuTile(
                  icon: Iconsax.document_upload,
                  title: 'Upload Data',
                  subTitle: 'Upload Data to your Cloud Storage',
                  onTap: () => Get.to(() => const UploadScreen()),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.location,
                  title: 'Geolocation',
                  subTitle: 'Get recommendation based on location',
                  trailing: Switch(value: true, onChanged: (value) {}),
                  onTap: () {},
                ),
                TSettingsMenuTile(
                  icon: Iconsax.security_user,
                  title: 'Safe Mode',
                  subTitle: 'Search results made safe for all ages',
                  trailing: Switch(
                      value: false, onChanged: (value) => {value = !value}),
                ),
                TSettingsMenuTile(
                  icon: Iconsax.image,
                  title: 'HD Image Quality',
                  subTitle: 'Set image quality to high definition',
                  trailing: Switch(value: false, onChanged: (value) {}),
                  onTap: () {},
                ),

                ///LOGOUT BUTTON
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () => controller.logout(),
                        child: const Text("Logout"))),
                const SizedBox(
                  height: TSizes.spaceBtwSections * 2.5,
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
