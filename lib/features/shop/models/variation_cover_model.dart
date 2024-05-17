class VariationCoverModel {
  String coverType;

  VariationCoverModel({this.coverType = ''});

  // Empty function for clean code
  static VariationCoverModel empty() => VariationCoverModel(coverType: '');

  //Json format
  toJson() {
    return {'CoverType': coverType};
  }

  // Map Json Document Snapshot from firebase to model
  factory VariationCoverModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return VariationCoverModel.empty();
    return VariationCoverModel(coverType: data['CoverType'] ?? '');
  }
}
