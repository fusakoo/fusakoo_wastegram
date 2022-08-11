import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wastegram/wastegram.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static Future<void> reportError(dynamic error, dynamic stackTrace) async {
    // if (Foundation.kDebugMode) {
    //   print(stackTrace);
    //   return;
    // }
    final sentryId =
        await Sentry.captureException(
          error, 
          stackTrace: stackTrace
        );
  }

  @override
  Widget build(BuildContext context) {
    // throw StateError('Test error');
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
                  wastepost: args.wastePost
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
