import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  final DateTime postDate;
  final String imageURL;
  final int wasteCount;
  final double lat;
  final double lon;

  const DetailsScreen({
    Key? key,
    required this.postDate,
    required this.imageURL,
    required this.wasteCount,
    required this.lat,
    required this.lon
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
        title: Text('Wastegram'),
        centerTitle: true
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          postDateDetailFormat(widget.postDate),
          SizedBox(height: 40),
          displayImage(widget.imageURL),
          SizedBox(height: 40),
          Text('${widget.wasteCount} items'),
          SizedBox(height: 40),
          Text('Location: (${widget.lat}, ${widget.lon})')
        ],
      )
    );
  }

  Widget postDateDetailFormat(DateTime postDate) {
    final DateFormat formatter = DateFormat('EEEE, MMMM d, y');
    return Text(formatter.format(postDate));
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