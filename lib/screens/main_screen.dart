import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wastegram'),
        centerTitle: true
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.docs != null &&
                snapshot.data!.docs.isNotEmpty
              ) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data!.docs[index];
                    final WastePost wastePost = WastePost.fromSnapshot(post);

                    return Semantics(
                      onTapHint: 'View details of the post',
                      child: ListTile(
                          title: Text(wastePost.getDateListFormat),
                          trailing: circularBackdrop(context, Text(wastePost.getQuantityString)),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              DetailsScreen.routeName,
                              arguments: PostDetailsScreenArguments(wastePost)
                            );
                          },
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: Semantics(
        button: true,
        onTapHint: 'Select an image',
        child: NewPostButton(),
      ),
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
