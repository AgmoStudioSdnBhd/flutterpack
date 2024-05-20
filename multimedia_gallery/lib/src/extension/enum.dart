/// Listing type.
/// Option: [ListingType.image],[ListingType.audio],[ListingType.video]
enum ListingType {
  image(0),
  video(1),
  audio(2);

  /// Listing index. To return the index to select the bottom tab.
  final int num;

  const ListingType(this.num);

  /// Localize the selected index / ListingType
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
