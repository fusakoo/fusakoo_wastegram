class PostDTO {
  late DateTime postDate;
  late String? imageURL;
  late int quantity;
  late double? latitude;
  late double? longtitude;

  @override
  String toString() {
    return 'postDate: $postDate, imageURL: $imageURL, quantity: $quantity, Lat/Long: ($latitude, $longtitude)';
  }
}