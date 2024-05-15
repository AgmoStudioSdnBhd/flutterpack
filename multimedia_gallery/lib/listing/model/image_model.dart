class ImageModel {
  String? name;
  String? path;
  String? uploadedDate;

  ImageModel(
      {required this.name, required this.path, required this.uploadedDate});

  ImageModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    path = json["path"];
    uploadedDate = json["uploadedDate"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["name"] = name;
    data["path"] = path;
    data["uploadedDate"] = uploadedDate;
    return data;
  }
}
