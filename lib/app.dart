import 'package:flutter/material.dart';
import 'package:wastegram/wastegram.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wastegram',
      theme: ThemeData.dark(),
      initialRoute: MainScreen.routeName,
            onGenerateRoute: (settings) {
        switch (settings.name) {
          case MainScreen.routeName:
            return MaterialPageRoute(
              builder: (context) {
                return const MainScreen();
              }
            );
          case 'detailsScreen':
            final args = settings.arguments as PostDetailsScreenArguments;
            return MaterialPageRoute(
              builder: (context) {
                return DetailsScreen(
                  postDate: args.postDate,
                  imageURL: args.imageURL,
                  wasteCount: args.wasteCount,
                  lat: args.latitude,
                  lon: args.longtitude
                );
              }
            );
          case 'newPostScreen':
            return MaterialPageRoute(
              builder: (context) {
                return const NewPostScreen(
                );
              }
            );
          default:
            return null;
        }
      },
    );
  }
}
