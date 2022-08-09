import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final DateFormat formatter = DateFormat('EEEE, MMMM d, y');
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wastegram'),
        centerTitle: true
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('posts').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.docs != null &&
                snapshot.data!.docs.isNotEmpty
              ) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data!.docs[index];
                    return ListTile(
                        title: Text(formatter.format(post['post_date'].toDate())),
                        trailing: circularBackdrop(context, Text(post['waste_count'].toString())),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: NewPostButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget circularBackdrop(BuildContext context, Text text) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
      child: text
    );
  }
}

class NewPostButton extends StatelessWidget {
  final picker = ImagePicker();
  var locationService = Location();

  NewPostButton({Key? key}) : super(key: key);

  /*
   * Citation for the following function:
   * Date: 08/08/2022
   * Adopted from 'Exploration: Platform Hardware Services'
   * Source URL: https://canvas.oregonstate.edu/courses/1878837/pages/exploration-platform-hardware-services
   * Source Code: share_location_screen.dart
   */
  Future getLocation() async {
    LocationData? locationData;

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
    print(locationData.latitude);
    print(locationData.longitude);
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
      final url = await storageReference.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print('Failed with error \'${e.code}\': ${e.message}');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
            String? url = await getImage();
            LocationData? locationData = await getLocation();
            if (url != null) {
              if (locationData != null) {
                print('Ready to proceed');
              }
            }
            // print(url);
            // print(locationData.latitude);
            // print(locationData.longitude);
            // Navigator.of(context).pushNamed(
            //   NewPostScreen.routeName
            // );

            // FirebaseFirestore.instance
            //   .collection('posts')
            //   .add({
            //     'post_date': DateTime.now(),
            //     'waste_count': 10,
            //     'lat': 5,
            //     'lon': 0.5
            //   });
          },
        
    );
  }
}
