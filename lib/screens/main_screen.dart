import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastegram/wastegram.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final DateFormat formatter = DateFormat('EEEE, MMMM d, y');

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
                        trailing: Text(post['waste_count'].toString()),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: NewEntryButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/*
 * As an example I have added functionality to add an entry to the collection
 * if the button is pressed
 */
class NewEntryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
            Navigator.of(context).pushNamed(
              NewPostScreen.routeName
            );
          },
        
        // onPressed: () {
        //   FirebaseFirestore.instance
        //       .collection('posts')
        //       .add({
        //         'post_date': DateTime.now(),
        //         'waste_count': 10,
        //         'lat': 5,
        //         'lon': 0.5
        //       });
        // }
    );
  }
}
