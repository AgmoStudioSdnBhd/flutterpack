enum ListingType {
  image(0),
  video(1),
  audio(2);

  final int num;

  const ListingType(this.num);

  String localizeTitle() {
    switch (this) {
      case ListingType.image:
        return 'Images';
      case ListingType.audio:
        return 'Audio';
      case ListingType.video:
        return 'Video';
    }
  }
}
