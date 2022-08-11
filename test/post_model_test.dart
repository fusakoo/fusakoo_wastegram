import 'package:test/test.dart';
import 'package:wastegram/models/post_model.dart';

void main() {
  test('Post models assigned with various data types should return expected values using getter.', () {
    final date = DateTime.parse('2022-08-02');
    const imageURL = 'foobar';
    const quantity = 1;
    const latitude = 1.0;
    const longtitude = -1.0;

    final post = WastePost(
      date: date, 
      imageURL: imageURL, 
      quantity: quantity, 
      latitude: latitude,
      longtitude: longtitude
    );

    expect(post.getDate, date);
    expect(post.getImageURL, imageURL);
    expect(post.getQuantity, quantity);
    expect(post.getLatitude, latitude);
    expect(post.getLongtitude, longtitude);
  });
}
