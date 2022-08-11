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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: Center(
            child: Column(
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
            ),
          ),
        ),
      )
    );
  }

  Widget displayImage(String url) {
    return Image.network(
      url,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}