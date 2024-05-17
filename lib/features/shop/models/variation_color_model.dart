class VariationColorModel {
  String color;

  VariationColorModel({this.color = ''});

  // Empty function for clean code
  static VariationColorModel empty() => VariationColorModel(color: '');

  //Json format
  toJson() {
    return {'Color': color};
  }

  // Map Json Document Snapshot from firebase to model
  factory VariationColorModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return VariationColorModel.empty();
    return VariationColorModel(color: data['Color'] ?? '');
  }
}
