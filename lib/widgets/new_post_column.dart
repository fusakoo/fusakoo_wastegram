import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wastegram/wastegram.dart';

class NewPostColumn extends StatelessWidget {
  final String? url;
  final PostDTO postDTO; 
  final GlobalKey<FormState> formKey;
  final LocationData? locationData;

  const NewPostColumn({
    required this.url,
    required this.postDTO,
    required this.formKey,
    required this.locationData,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        displayImagePreview(url),
        const SizedBox(height: 20),
        QuantityInputField(postDTO: postDTO),
        const SizedBox(height: 50),
        Semantics(
          button: true,
          onTapHint: 'Save a post',
          child: FloatingActionButton.extended(
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text('Upload'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (url != null) {
                  formKey.currentState!.save();
                  updateFirebase(postDTO, url, locationData);
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        )
      ]
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
      'date': postDTO.postDate,
      'imageURL': postDTO.imageURL,
      'quantity': postDTO.quantity,
      'latitude': postDTO.latitude,
      'longtitude': postDTO.longtitude
    });
  }

  Widget displayImagePreview(String? url) {
    if (url != null) {
      return Image.network(url);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}