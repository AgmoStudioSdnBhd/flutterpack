class AudioModel {
  String? image;
  String? path;
  String? audioName;
  String? artistName;

  AudioModel(
      {required this.image,
      required this.artistName,
      required this.audioName,
      required this.path});

  AudioModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    path = json["path"];
    audioName = json["songName"];
    artistName = json["artistName"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['path'] = path;
    data['songName'] = audioName;
    data['artistName'] = artistName;
    return data;
  }
}
