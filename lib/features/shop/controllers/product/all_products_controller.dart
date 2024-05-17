import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_store/data/repositories/product/product_repository.dart';
import 'package:t_store/features/shop/controllers/product/product_controller.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/popups/loaders.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Alphabetical'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> productList = <ProductModel>[].obs;

  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try {
      if (query == null) return [];

      final products = await repository.fetchProductsByQuery(query);

      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Uh oh', message: e.toString());
      return [];
    }
  }

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;
    switch (sortOption) {
      case 'Alphabetical':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Price Desc.':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Price Asc.':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Newest':
        products.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 'By Sale':
        products.sort((a, b) {
          if (b.salePrice > 0) {
            return b.salePrice.compareTo(a.salePrice);
          } else if (a.salePrice > 0) {
            return -1;
          } else {
            return 1;
          }
        });
        break;
      default:
        products.sort((a, b) => a.title.compareTo(b.title));
    }
  }

  void assignProducts(List<ProductModel> products) {
    this.products.assignAll(products);
    sortProducts('Alphabetical');
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      if (query.isEmpty) {
        // If the search query is empty, clear the products list
        return [];
      } else {
        // Fetch products based on the search query
        final List<ProductModel> productList =
            await repository.fetchProductsBySearch(query);
        products.value = productList;
        return products;
      }
    } catch (e) {
      // Handle any errors
      print('Error searching products: $e');
      return [];
    }
  }
}
