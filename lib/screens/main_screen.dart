import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                        title: postDateListFormat(post['post_date'].toDate()),
                        trailing: circularBackdrop(context, Text(post['waste_count'].toString())),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            DetailsScreen.routeName,
                            arguments: PostDetailsScreenArguments(
                              post['post_date'].toDate(),
                              post['image'],
                              post['waste_count'], 
                              post['lat'], 
                              post['lon']
                            )
                          );
                        },
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

  Widget postDateListFormat(DateTime postDate) {
    final DateFormat formatter = DateFormat('E, MMMM d, y');
    return Text(formatter.format(postDate));
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
