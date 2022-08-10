class PostDTO {
  late DateTime postDate;
  late String? imageURL;
  late int wasteCount;
  late double? latitude;
  late double? longtitude;

  @override
  String toString() {
    return 'postDate: $postDate, url: $imageURL, wasteCount: $wasteCount, Lat/Long: ($latitude, $longtitude)';
  }
}