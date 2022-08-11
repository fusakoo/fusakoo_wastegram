import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wastegram/wastegram.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
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
    });
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