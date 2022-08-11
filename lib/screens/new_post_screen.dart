import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  final formKey = GlobalKey<FormState>();
  final postValues = PostDTO();

  @override
  void initState() {
    super.initState();
    getImage();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        centerTitle: true
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: Form(
            key: formKey,
            child: NewPostColumn(url: url, postDTO: postValues, formKey: formKey, locationData: locationData)
          ),
        ),
      ),
    );
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
      var serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationService.requestService();
        if (!serviceEnabled) {
          print('Failed to enable service. Returning.');
          Navigator.of(context).pop();
          return;
        }
      }
      var permissionGranted = await locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
          Navigator.of(context).pop();
        }
      }
      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    setState(() {});
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
      Navigator.of(context).pop();
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
}