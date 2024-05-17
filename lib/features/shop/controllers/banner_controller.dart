import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/data/repositories/banners/banner_repository.dart';
import 'package:t_store/features/shop/models/banner_model.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class BannerController extends GetxController {
  final carouselCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  RxString newDocumentId = ''.obs;
  final bannerRepository = Get.put(BannerRepository());
  final bannerName = TextEditingController();
  final bannerImage = TextEditingController();
  final active = true.obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  void updatePageIndicator(index) {
    carouselCurrentIndex.value = index;
  }

  //Add Banners
  Future<void> addBanner() async {
    try {
      //Start loader
      TFullScreenLoader.openLoadingDialog(
          'Adding banner...', TImages.docerAnimation);

      await bannerRepository.addBanner(BannerModel(
        imageUrl: bannerImage.text.trim(),
        active: active.value,
        targetScreen: '',
      ));

      TLoaders.successSnackBar(
          title: 'Banner Added', message: "Successfully added the new banner.");
      //Close Loader
      TFullScreenLoader.stopLoading();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh sheesh !', message: e.toString());
      TFullScreenLoader.stopLoading();
    }
  }

  //Fetch Banners
  Future<void> fetchBanners() async {
    try {
      //Show loader
      isLoading.value = true;

      // Fetch categories from data source (Firestore,api etc)
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();
      // update the categories list
      this.banners.assignAll(banners);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh snap !', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }
}
