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
  State<DetailsScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wastegram'),
        centerTitle: true
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.wastepost.getDateDetailFormat,
            style: Theme.of(context).textTheme.headline5
          ),
          const SizedBox(height: 40),
          displayImage(widget.wastepost.getImageURL),
          const SizedBox(height: 40),
          Text(
            '${widget.wastepost.getQuantity} items',
            style: Theme.of(context).textTheme.headline6
          ),
          const SizedBox(height: 40),
          Text(
            'Location: (${widget.wastepost.getLatitude}, ${widget.wastepost.getLongtitude})',
            style: Theme.of(context).textTheme.bodySmall
          )
        ],
      )
    );
  }

  // TODO
  // Put this widget to parent (app.dart)?
  Widget displayImage(String? url) {
    if (url != null) {
      return Image.network(url);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}