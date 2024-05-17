import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/data/repositories/product/product_repository.dart';
import 'package:t_store/features/shop/models/category_model.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/popups/full_screen_loader.dart';
import 'package:t_store/utils/popups/loaders.dart';

import '../../../data/repositories/categories/category_repository.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  //Variables
  RxString newDocumentId = ''.obs;
  final isLoading = true.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  final categoryName = TextEditingController();
  final categoryImage = TextEditingController();
  final parentId = TextEditingController();
  final isFeatured = true.obs;
  GlobalKey<FormState> categoryFormkey = GlobalKey<FormState>();

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> addCategory() async {
    try {
      //Start loader
      TFullScreenLoader.openLoadingDialog(
          'Adding category...', TImages.docerAnimation);

      final db = FirebaseFirestore.instance;
      CollectionReference ref = db.collection('Categories');
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

      if (querySnapshot.docs.isEmpty) {
        newDocumentId.value = "1";
      } else {
        int lastDocumentId = int.parse(querySnapshot.docs.first.get('Id'));
        newDocumentId.value = (lastDocumentId + 1).toString();
      }

      await _categoryRepository.addCategory(CategoryModel(
          id: newDocumentId.value,
          name: categoryName.text.trim(),
          image: categoryImage.text.trim(),
          parentId: '',
          isFeatured: isFeatured.value));

      TLoaders.successSnackBar(
          title: 'Category Added',
          message: "Successfully added the new category");
      //Close Loader
      TFullScreenLoader.stopLoading();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh sheesh !', message: e.toString());
      TFullScreenLoader.stopLoading();
    }
  }

  // Load category data
  Future<void> fetchCategories() async {
    try {
      //Show loader
      isLoading.value = true;

      //Save categories to firestore
      // await _categoryRepository.uploadDummyData(categories);

      // Fetch categories from data source (Firestore,api etc)
      final categories = await _categoryRepository.getAllCategories();

      // update the categories list
      allCategories.assignAll(categories);

      // Filter featured categories
      featuredCategories.assignAll(allCategories
          .where((category) => category.isFeatured && category.parentId.isEmpty)
          .take(8)
          .toList());
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh snap !', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }

  //Load selected Category data
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final subCategories =
          await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
      return [];
    }
  }

  // Get category or sub category products
  Future<List<ProductModel>> getCategoryProducts(
      {required String categoryId, int limit = 4}) async {
    try {
      final products = await ProductRepository.instance
          .getProductsForCategory(categoryId: categoryId, limit: limit);
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
      return [];
    }
  }
}
