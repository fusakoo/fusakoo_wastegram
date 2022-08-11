import 'package:flutter/material.dart';
import 'package:wastegram/wastegram.dart';

class PostDetails extends StatelessWidget {
  final WastePost wastepost;

  const PostDetails({
    required this.wastepost,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                wastepost.getDateDetailFormat,
                style: Theme.of(context).textTheme.headline5
              ),
              const SizedBox(height: 40),
              displayImage(wastepost.getImageURL),
              const SizedBox(height: 40),
              Text(
                '${wastepost.getQuantity} items',
                style: Theme.of(context).textTheme.headline6
              ),
              const SizedBox(height: 40),
              Text(
                'Location: (${wastepost.getLatitude}, ${wastepost.getLongtitude})',
                style: Theme.of(context).textTheme.bodySmall
              )
            ],
          ),
        ),
      ),
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