import 'package:t_store/features/shop/models/category_model.dart';
import 'package:t_store/utils/constants/image_strings.dart';

class DummyData {
  static final List<CategoryModel> categories = [
    CategoryModel(
        id: '3', name: 'Fitness', image: TImages.sportIcon, isFeatured: true),
    CategoryModel(
        id: '4', name: 'Dorime', image: TImages.sportIcon, isFeatured: true)
  ];
}
