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

  final formKey = GlobalKey<FormState>();
  final postValues = PostDTO();

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
        displayImage(url),
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            autofocus: true,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'Input the waste count'
            ),
            keyboardType: TextInputType.number,
            validator: (value) => validateCount(value!),
            onChanged: (value) {
              postValues.wasteCount = int.parse(value);
            }
          ),
        ),
        SizedBox(height: 40),
        ElevatedButton(
          child: Icon(Icons.cloud_upload_outlined),
          onPressed: () {
            updateFirebase(postValues, url, locationData);
            Navigator.of(context).pop();
          },
        )
      ]),
    );
  }

  void updateFirebase(PostDTO postDTO, String? url, LocationData? locationData) {
    postDTO.postDate = DateTime.now();
    postDTO.imageURL = url;
    postDTO.latitude = locationData!.latitude;
    postDTO.longtitude = locationData.longitude;

    FirebaseFirestore.instance
    .collection('posts')
    .add({
      'post_date': postDTO.postDate,
      'image': postDTO.imageURL,
      'waste_count': postDTO.wasteCount,
      'lat': postDTO.latitude,
      'lon': postDTO.longtitude
    });
  }

  Widget displayImage(String? url) {
    if (url != null) {
      return Image.network(url);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  String? validateCount(String? count) {
    if (count == null) {
      return 'Please input a number';
    }
  }
}