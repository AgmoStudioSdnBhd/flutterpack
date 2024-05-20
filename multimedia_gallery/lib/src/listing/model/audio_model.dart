/// The audio model. To get the data from the model to display.
class AudioModel {
  /// The image path.
  String? image;

  /// The audio file path.
  String? path;

  /// The audio file name.
  String? audioName;

  /// The audio artist name.
  String? artistName;

  /// Audio model constructor.
  AudioModel(
      {required this.image,
      required this.artistName,
      required this.audioName,
      required this.path});

  /// The audio model assignation. To allocate the data into a Map
  /// to become a model.
  AudioModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    path = json["path"];
    audioName = json["songName"];
    artistName = json["artistName"];
  }

  /// The audio model assignation. To pass back the data as json
  /// response.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['path'] = path;
    data['songName'] = audioName;
    data['artistName'] = artistName;
    return data;
  }
}
