import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      initialRoute: "/",
      onGenerateRoute: AppRouter.generatedRoute,
    );
  }
}

