import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/shop/models/brand_model.dart';
import 'package:t_store/features/shop/models/product_attribute_model.dart';
import 'package:t_store/features/shop/models/product_variation_model.dart';
import 'package:t_store/features/shop/models/variation_color_model.dart';
import 'package:t_store/features/shop/models/variation_cover_model.dart';
import 'package:t_store/utils/constants/enums.dart';
import 'package:t_store/utils/popups/loaders.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../models/product_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  RxString newDocumentId = ''.obs;
  RxString newVarId = ''.obs;
  RxString newVarId2 = ''.obs;

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final productName = TextEditingController();
  final productDescription = TextEditingController();
  final productPrice = TextEditingController();
  final productSalePrice = TextEditingController();
  final isFeatured = true.obs;
  final isFeaturedBrand = false.obs;
  final productStock = TextEditingController();
  final productImage = TextEditingController();
  final List<TextEditingController> productAdditionalImage = [];
  final productType = "ProductType.Single".obs;
  final brandImage = TextEditingController();
  final brandName = TextEditingController();
  final productsCount = TextEditingController();
  final varImage = TextEditingController();
  final varDescription = TextEditingController();
  final varPrice = TextEditingController();
  final varSalePrice = TextEditingController();
  final varStock = TextEditingController();
  final varCover = TextEditingController();
  final varColor = TextEditingController();
  final varImage2 = TextEditingController();
  final varDescription2 = TextEditingController();
  final varPrice2 = TextEditingController();
  final varSalePrice2 = TextEditingController();
  final varStock2 = TextEditingController();
  final varCover2 = TextEditingController();
  final varColor2 = TextEditingController();
  final attributeName = "Color".obs;
  final List<TextEditingController> attributeValue = [];
  List<String> extractTextFromAttributeValueList() {
    List<String> extractedValues = [];
    for (TextEditingController controller in attributeValue) {
      extractedValues.add(controller.text.trim());
    }
    return extractedValues;
  }

  List<String> extractTextFromImageTextFields() {
    List<String> extractedTexts = [];
    for (TextEditingController controller in productAdditionalImage) {
      extractedTexts.add(controller.text.trim());
    }
    return extractedTexts;
  }

  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  Future<void> addSingleProduct() async {
    try {
      //Start loader
      TFullScreenLoader.openLoadingDialog(
          'Adding product...', TImages.docerAnimation);

      final db = FirebaseFirestore.instance;
      CollectionReference ref = db.collection('Products');
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
        newVarId.value += (lastDocumentId + 2).toString();
        newVarId2.value += (lastDocumentId + 3).toString();
      }

      await productRepository.addProduct(ProductModel(
        id: newDocumentId.value,
        categoryId: '',
        title: productName.text.trim(),
        description: productDescription.text.trim(),
        stock: int.parse(productStock.text.trim()),
        price: double.parse(productPrice.text.trim()),
        salePrice: double.parse(productSalePrice.text.trim()),
        thumbnail: productImage.text.trim(),
        images: extractTextFromImageTextFields(),
        productType: "ProductType.single",
        isFeatured: isFeatured.value,
        brand: BrandModel(
            id: newDocumentId.value,
            name: brandName.text.trim(),
            productsCount: 2,
            isFeatured: isFeaturedBrand.value),
      ));

      TLoaders.successSnackBar(
          title: 'Product Added', message: "Successfully added the new book");
      //Close Loader
      TFullScreenLoader.stopLoading();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh sheesh !', message: e.toString());
    }
  }

  ///__________COLOR PRODUCTS____________________
  Future<void> addColorProduct() async {
    try {
      //Start loader
      TFullScreenLoader.openLoadingDialog(
          'Adding product...', TImages.docerAnimation);

      final db = FirebaseFirestore.instance;
      CollectionReference ref = db.collection('Products');
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
        newVarId.value += (lastDocumentId + 2).toString();
        newVarId2.value += (lastDocumentId + 3).toString();
      }
      await productRepository.addProduct(ProductModel(
          id: newDocumentId.value,
          categoryId: '',
          title: productName.text.trim(),
          description: productDescription.text.trim(),
          stock: int.parse(productStock.text.trim()),
          price: double.parse(productPrice.text.trim()),
          salePrice: double.parse(productSalePrice.text.trim()),
          thumbnail: productImage.text.trim(),
          images: extractTextFromImageTextFields(),
          productType: "ProductType.variable",
          isFeatured: isFeatured.value,
          brand: BrandModel(
              id: newDocumentId.value,
              name: brandName.text.trim(),
              productsCount: 2,
              isFeatured: isFeaturedBrand.value),
          productAttributes: [
            ProductAttributeModel(
                name: "Color", values: extractTextFromAttributeValueList())
          ],
          productVariations: [
            ProductVariationModel(
                id: newVarId.value,
                image: varImage.text.trim(),
                description: varDescription.text.trim(),
                price: double.parse(varPrice.text.trim()),
                salePrice: double.parse(varSalePrice.text.trim()),
                stock: int.parse(varStock.text.trim()),
                attributeValues:
                    VariationColorModel(color: varColor.text.trim()).toJson()),
            ProductVariationModel(
                id: newVarId2.value,
                image: varImage2.text.trim(),
                description: varDescription2.text.trim(),
                price: double.parse(varPrice2.text.trim()),
                salePrice: double.parse(varSalePrice2.text.trim()),
                stock: int.parse(varStock2.text.trim()),
                attributeValues:
                    VariationColorModel(color: varColor2.text.trim()).toJson())
          ]));

      TLoaders.successSnackBar(
          title: 'Product Added', message: "Successfully added the new book");
      //Close Loader
      TFullScreenLoader.stopLoading();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh sheesh !', message: e.toString());
    }
  }

  ///COVER TYPE PRODUCTS_______________________________________________________________________
  Future<void> addCoverProducts() async {
    try {
      //Start loader
      TFullScreenLoader.openLoadingDialog(
          'Adding product...', TImages.docerAnimation);

      final db = FirebaseFirestore.instance;
      CollectionReference ref = db.collection('Products');
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
        newVarId.value += (lastDocumentId + 2).toString();
        newVarId2.value += (lastDocumentId + 3).toString();
      }
      await productRepository.addProduct(ProductModel(
          id: newDocumentId.value,
          categoryId: '',
          title: productName.text.trim(),
          description: productDescription.text.trim(),
          stock: int.parse(productStock.text.trim()),
          price: double.parse(productPrice.text.trim()),
          salePrice: double.parse(productSalePrice.text.trim()),
          thumbnail: productImage.text.trim(),
          images: extractTextFromImageTextFields(),
          productType: "ProductType.variable",
          isFeatured: isFeatured.value,
          brand: BrandModel(
              id: newDocumentId.value,
              name: brandName.text.trim(),
              productsCount: 2,
              isFeatured: isFeaturedBrand.value),
          productAttributes: [
            ProductAttributeModel(
                name: "CoverType", values: extractTextFromAttributeValueList())
          ],
          productVariations: [
            ProductVariationModel(
                id: newVarId.value,
                image: varImage.text.trim(),
                description: varDescription.text.trim(),
                price: double.parse(varPrice.text.trim()),
                salePrice: double.parse(varSalePrice.text.trim()),
                stock: int.parse(varStock.text.trim()),
                attributeValues:
                    VariationCoverModel(coverType: varCover.text.trim())
                        .toJson()),
            ProductVariationModel(
                id: newVarId2.value,
                image: varImage2.text.trim(),
                description: varDescription2.text.trim(),
                price: double.parse(varPrice2.text.trim()),
                salePrice: double.parse(varSalePrice2.text.trim()),
                stock: int.parse(varStock2.text.trim()),
                attributeValues:
                    VariationCoverModel(coverType: varCover2.text.trim())
                        .toJson())
          ]));

      TLoaders.successSnackBar(
          title: 'Product Added', message: "Successfully added the new book");
      //Close Loader
      TFullScreenLoader.stopLoading();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh sheesh !', message: e.toString());
    }
  }

  void fetchFeaturedProducts() async {
    try {
      //Show loader while loading products
      isLoading.value = true;

      //fetch Products
      final products = await productRepository.getFeaturedProducts();

      //assign products
      featuredProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Uh Oh! error while loading products', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try {
      final products = await productRepository.getFeaturedProducts();
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Uh Oh! error while loading products', message: e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final products = await productRepository.getAllProducts();
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Uh Oh! error while loading products', message: e.toString());
      return [];
    }
  }

  //Get the product price or price range from variations
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    //if no variations exist return the single price
    if (product.productType == ProductType.single.toString()) {
      return (product.salePrice > 0 ? product.salePrice : product.price)
          .toString();
    } else {
      for (var variation in product.productVariations!) {
        //Determine the price to consider sale price if available, otherwise regular price
        double priceToConsider =
            variation.salePrice > 0.0 ? variation.salePrice : variation.price;

        //Update smallest & largest prices
        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }
        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      // If smallest & largest prices are the same, return a single price
      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toString();
      } else {
        return '$smallestPrice - ₹$largestPrice';
      }
    }
  }

  //Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice * 100);
    return percentage.toStringAsFixed(0);
  }

  //Check Product Stock Status
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}
