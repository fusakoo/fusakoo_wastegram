import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wastegram/wastegram.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final picker = ImagePicker();
  var totalQuantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: mainTitle(),
        centerTitle: true
      ),
      body: const PostList(),
      floatingActionButton: Semantics(
        button: true,
        onTapHint: 'Select an image',
        child: const NewPostButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget mainTitle() {
    var totalQuantity = 0;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          totalQuantity = 0;
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            int quantity = snapshot.data!.docs[i]['quantity'].toInt();
            totalQuantity += quantity;
          }
          return Text('Wastegram - $totalQuantity'); 
        } 
        return const Text('Wastegram');
      });
  }
}
