import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
  // runApp(Provider(
  //   create: (context) => AppDb(),
  //   child: MyApp(),
  //   dispose: (context, AppDb db) => db.close(),
  // ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRouter.audioPlayerListWithGetItScreen,
      onGenerateRoute: AppRouter.generatedRoute,
    );
  }
}
