/// The video model. To get the data from the model to display.
class VideoModel {
  /// The video path.
  String? path;

  /// The video name.
  String? name;

  /// The video uploaded date.
  String? uploadedDate;

  /// The video model constructor.
  VideoModel(
      {required this.path, required this.name, required this.uploadedDate});

  /// The video model assignation. To allocate the data into a Map
  /// to become a model.
  VideoModel.fromJson(Map<String, dynamic> json) {
    path = json["path"];
    name = json["name"];
    uploadedDate = json["uploadedDate"];
  }

  /// The video model assignation. To pass back the data as json
  /// response.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["path"] = path;
    data["name"] = name;
    data["uploadedDate"] = uploadedDate;
    return data;
  }
}
