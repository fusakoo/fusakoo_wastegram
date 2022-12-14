import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WastePost {
  late DateTime date;
  late String imageURL;
  late int quantity;
  late double latitude;
  late double longtitude;

  WastePost({
    required this.date,
    required this.imageURL, 
    required this.quantity, 
    required this.latitude, 
    required this.longtitude
  });

  WastePost.fromSnapshot(QueryDocumentSnapshot<Object?> post) :
    date = post['date'].toDate(),
    imageURL = post['imageURL'],
    quantity = post['quantity'],
    latitude = post['latitude'],
    longtitude = post['longtitude']
  ;
  
  DateTime get getDate => date;
  String get getDateListFormat {
    final DateFormat formatter = DateFormat('E, MMMM d, y');
    final String formatted = formatter.format(date);
    return formatted;
  }
  String get getDateDetailFormat {
    final DateFormat formatter = DateFormat('EEEE, MMMM d, y');
    final String formatted = formatter.format(date);
    return formatted;
  }

  String get getImageURL => imageURL;
  int get getQuantity => quantity;
  String get getQuantityString => quantity.toString();
  double get getLatitude => latitude;
  double get getLongtitude => longtitude;
}