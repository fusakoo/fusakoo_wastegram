import 'package:flutter/material.dart';

class WGScaffold extends StatelessWidget {
  const WGScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Wastegram'))
      ),
      body: Placeholder()
    );
  }
}