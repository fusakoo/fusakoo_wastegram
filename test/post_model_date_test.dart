import 'package:test/test.dart';
import 'package:wastegram/models/post_model.dart';

void main() {
  test('Post model converts the date to an expected output string.', () {
    final date = DateTime.parse('2022-08-02');
    const imageURL = 'foobar';
    const quantity = 1;
    const latitude = 1.0;
    const longtitude = -1.0;

    const dateListFormat = 'Tue, August 2, 2022';
    const dateDetailFormat = 'Tuesday, August 2, 2022';

    final post = WastePost(
      date: date, 
      imageURL: imageURL, 
      quantity: quantity, 
      latitude: latitude,
      longtitude: longtitude
    );
    
    expect(post.getDate, date);
    expect(post.getDateListFormat, dateListFormat);
    expect(post.getDateDetailFormat, dateDetailFormat);
  });
}
