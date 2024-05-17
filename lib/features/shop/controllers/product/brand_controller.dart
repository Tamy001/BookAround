import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/data/repositories/product/product_repository.dart';
import 'package:t_store/features/shop/models/brand_model.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/popups/loaders.dart';

import '../../../../data/repositories/brands/brand_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();
  RxString newDocumentId = ''.obs;
  final isLoading = true.obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());
  final brandName = TextEditingController();
  final productsCount = TextEditingController();
  final isFeatured = true.obs;

  @override
  void onInit() {
    getFeaturedBrands();
    super.onInit();
  }

  //UPLOAD AUTHORS
  Future<void> addBrand() async {
    try {
      //Start loader
      TFullScreenLoader.openLoadingDialog(
          'Adding category...', TImages.docerAnimation);

      final db = FirebaseFirestore.instance;
      CollectionReference ref = db.collection('Brands');
      QuerySnapshot querySnapshot =
          await ref.orderBy('Id', descending: true).get(); // Removed the limit

      if (querySnapshot.docs.isEmpty) {
        newDocumentId.value = "1";
      } else {
        List<int> ids =
            querySnapshot.docs.map((doc) => int.parse(doc.get('Id'))).toList();
        ids.sort((a, b) => b.compareTo(a)); // Sort in descending order
        int lastDocumentId = ids.first;
        newDocumentId.value = (lastDocumentId + 1).toString();
      }

      await brandRepository.addBrand(BrandModel(
          id: newDocumentId.value,
          name: brandName.text.trim(),
          productsCount: int.parse(productsCount.text.trim()),
          isFeatured: isFeatured.value));

      TLoaders.successSnackBar(
          title: 'Author Added', message: "Successfully added the new author.");
      //Close Loader
      TFullScreenLoader.stopLoading();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh sheesh !', message: e.toString());
      TFullScreenLoader.stopLoading();
    }
  }

  //lOAD AUTHORS
  Future<void> getFeaturedBrands() async {
    try {
      isLoading.value = true;
      final brands = await brandRepository.getAllBrands();

      allBrands.assignAll(brands);

      featuredBrands.assignAll(
          allBrands.where((brand) => brand.isFeatured ?? false).take(4));
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Uh oh', message: e.toString());
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get Brands for Category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      final brands = await brandRepository.getBrandsForCategory(categoryId);
      return brands;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  // Get Brand specific products from data source
  Future<List<ProductModel>> getBrandProducts(
      {required String brandId, int limit = -1}) async {
    try {
      final products = await ProductRepository.instance
          .getProductsForBrand(brandId: brandId, limit: limit);
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Uh oh', message: e.toString());
      return [];
    }
  }
}
