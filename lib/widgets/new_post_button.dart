import 'package:flutter/material.dart';
import 'package:wastegram/wastegram.dart';


class NewPostButton extends StatelessWidget {
  const NewPostButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.of(context).pushNamed(
            NewPostScreen.routeName
          );
        },
    );
  }
}