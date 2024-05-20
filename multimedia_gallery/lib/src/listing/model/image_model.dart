/// The image model. To get the data from the model to display.
class ImageModel {
  /// The image name.
  String? name;

  /// The image path.
  String? path;

  /// The uploadedDate.
  String? uploadedDate;

  /// The image model constructor.
  ImageModel(
      {required this.name, required this.path, required this.uploadedDate});

  /// The image model assignation. To allocate the data into a Map
  /// to become a model.
  ImageModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    path = json["path"];
    uploadedDate = json["uploadedDate"];
  }

  /// The image model assignation. To pass back the data as json
  /// response.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["name"] = name;
    data["path"] = path;
    data["uploadedDate"] = uploadedDate;
    return data;
  }
}
