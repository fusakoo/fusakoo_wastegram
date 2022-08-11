import 'package:flutter/material.dart';
import 'package:wastegram/wastegram.dart';

class DetailsScreen extends StatefulWidget {
  final WastePost wastepost;

  const DetailsScreen({
    Key? key,
    required this.wastepost,
  }) : super(key: key);

  static const routeName = 'detailsScreen';

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wastegram'),
        centerTitle: true
      ),
      body: PostDetails(wastepost: widget.wastepost)
    );
  }
}