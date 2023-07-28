import 'package:audio_player_list_with_drift/screen/add_audio_screen.dart';
import 'package:audio_player_list_with_drift/screen/audio_details_screen.dart';
import 'package:audio_player_list_with_drift/screen/audio_list_screen.dart';
import 'package:flutter/material.dart';

class AppRouter{

  static const String audioPlayerListScreen = '/';
  static const String addAudioScreen = '/addAudioScreen';
  static const String audioDetailsScreen = '/audioDetailsScreen';

  static Route<dynamic> generatedRoute(RouteSettings settings) {

    final screen;

    switch (settings.name){
      case audioPlayerListScreen:
        screen =  MaterialPageRoute(builder: (_) => const AudioListScreen());
        break;
      case addAudioScreen:
        screen =  MaterialPageRoute(builder: (_) => const AddAudioScreen());
        break;
      case audioDetailsScreen:
        screen =  MaterialPageRoute(builder: (_) => const AudioDetailsScreen());
        break;
      default:
        throw UnimplementedError('Unimplemented route: $settings.name');
    }
    return screen;
  }
}