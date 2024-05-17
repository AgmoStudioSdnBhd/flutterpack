class VideoModel {
  String? path;
  String? name;
  String? uploadedDate;

  VideoModel(
      {required this.path, required this.name, required this.uploadedDate});

  VideoModel.fromJson(Map<String, dynamic> json) {
    path = json["path"];
    name = json["name"];
    uploadedDate = json["uploadedDate"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["path"] = path;
    data["name"] = name;
    data["uploadedDate"] = uploadedDate;
    return data;
  }
}
