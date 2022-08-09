import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:wastegram/wastegram.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  static const routeName = 'newPostScreen';

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  String? url;
  final picker = ImagePicker();
  LocationData? locationData;
  var locationService = Location();

  @override
  void initState() {
    super.initState();
    getImage();
    getLocation();
  }

  /*
   * Citation for the following function:
   * Date: 08/08/2022
   * Adopted from 'Exploration: Platform Hardware Services'
   * Source URL: https://canvas.oregonstate.edu/courses/1878837/pages/exploration-platform-hardware-services
   * Source Code: share_location_screen.dart
   */
  Future getLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    setState(() {});
    // print(locationData.latitude);
    // print(locationData.longitude);
  }

  /*
   * Citation for the following function:
   * Date: 08/08/2022
   * Adopted from 'Exploration: Firebase Cloud Firestore & Storage'
   * Source URL: https://canvas.oregonstate.edu/courses/1878837/pages/exploration-firebase-cloud-firestore-and-storage
   * Source Code: camera_screen.dart
   */
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('File was not selected.');
      return;
    }
    try {
      File image = File(pickedFile.path); 
      var fileName = '${DateTime.now()}.jpg';
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;
      url = await storageReference.getDownloadURL();
      setState(() {});
    } on FirebaseException catch (e) {
      print('Failed with error \'${e.code}\': ${e.message}');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        centerTitle: true
      ),
      body: Column(children: [
        // TODO
        // Show circular if it's still loading or display a button to select if it returns null
        Placeholder(),
        SizedBox(height: 40),
        Text('Input the weight'),
        SizedBox(height: 40),
        Text('(${locationData?.latitude},${locationData?.longitude})'),
        SizedBox(height: 40),
        ElevatedButton(
          child: Text('Post it!'),
          onPressed: () {
            FirebaseFirestore.instance
              .collection('posts')
              .add({
                'post_date': DateTime.now(),
                'waste_count': 10,
                'lat': 5,
                'lon': 0.5
              });
            Navigator.of(context).pop();
            // Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
          },
        )
      ]),
    );
  }
}