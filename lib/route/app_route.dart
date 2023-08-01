import 'package:audio_player_list_with_drift/screen/add_audio_screen.dart';
import 'package:audio_player_list_with_drift/screen/audio_details_screen.dart';
import 'package:audio_player_list_with_drift/screen/edit_audio_screen.dart';
import 'package:audio_player_list_with_drift/screen/audio_list_screen.dart';
import 'package:flutter/material.dart';

class AppRouter{

  static const String audioPlayerListScreen = '/';
  static const String addAudioScreen = '/addAudioScreen';
  static const String audioDetailsScreen = '/audioDetailsScreen';
  static const String editAudioScreen = '/editAudioScreen';

  static Route<dynamic>? generatedRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name){
      case audioPlayerListScreen:
        return MaterialPageRoute(builder: (_) => const AudioListScreen());

      case addAudioScreen:
        return MaterialPageRoute(builder: (_) => AddAudioScreen(arguments: args,));

      case editAudioScreen:
        if(args is int){
          return MaterialPageRoute(builder: (_) => EditAudioScreen(audioId: args));
        }
        break;

      // case audioDetailsScreen:
        // if(args is int){
        //   return MaterialPageRoute(builder: (_) => AudioDetailsScreen(arguments: args));
        // }
        break;
      default:
        return _errorRoute();
        // throw UnimplementedError('Unimplemented route: $settings.name');
    }
  }

  static Route<dynamic> _errorRoute(){

    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("No route"),
        ),
        body: const Center(
          child: Text("Sorry, no route"),
        ),
      );
    });
  }
}