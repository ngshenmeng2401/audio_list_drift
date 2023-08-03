import 'package:audio_player_list_with_drift/screen/get_it/add_audio_get_it_screen.dart';
import 'package:audio_player_list_with_drift/screen/get_it/audio_details_get_it_screen.dart';
import 'package:audio_player_list_with_drift/screen/get_it/audio_list_get_it_screen.dart';
import 'package:audio_player_list_with_drift/screen/get_it/edit_audio_get_it_screen.dart';
import 'package:audio_player_list_with_drift/screen/provider/add_audio_provider_screen.dart';
import 'package:audio_player_list_with_drift/screen/provider/audio_details_provider_screen.dart';
import 'package:audio_player_list_with_drift/screen/provider/audio_list_provider_screen.dart';
import 'package:audio_player_list_with_drift/screen/provider/edit_audio_provider_screen.dart';
import 'package:audio_player_list_with_drift/widget/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class AppRouter{

  // static const String bottomNavigationBarWidget = '/';
  static const String audioPlayerListWithGetItScreen = '/';

  static const String audioPlayerListWithProviderScreen = '/audioPlayerListWithProviderScreen';
  static const String addAudioWithProviderScreen = '/addAudioWithProviderScreen';
  static const String audioDetailsWithProviderScreen = '/audioDetailsWithProviderScreen';
  static const String editAudioWithProviderScreen = '/editAudioWithProviderScreen';

  // static const String audioPlayerListWithGetItScreen = '/audioPlayerListWithGetItScreen';
  static const String addAudioWithGetItScreen = '/addAudioWithGetItScreen';
  static const String audioDetailsWithGetItScreen = '/audioDetailsWithGetItScreen';
  static const String editAudioWithGetItScreen = '/editAudioWithGetItScreen';

  static Route<dynamic>? generatedRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name){
      // case bottomNavigationBarWidget:
      //   return MaterialPageRoute(builder: (_) => const BottomNavigationBarWidget());

      case audioPlayerListWithProviderScreen:
        return MaterialPageRoute(builder: (_) => const AudioListWithProviderScreen());
      case addAudioWithProviderScreen:
        return MaterialPageRoute(builder: (_) => AddAudioWithProviderScreen(arguments: args,));

      case editAudioWithProviderScreen:
        return MaterialPageRoute(builder: (_) => EditAudioWithProviderScreen(arguments: args));

      case audioDetailsWithProviderScreen:
        return MaterialPageRoute(builder: (_) => AudioDetailsWithProviderScreen(arguments: args));

      case audioPlayerListWithGetItScreen:
        return MaterialPageRoute(builder: (_) => const AudioListWithGetItScreen());

      case addAudioWithGetItScreen:
        return MaterialPageRoute(builder: (_) => AddAudioWithGetItScreen(arguments: args,));

      case editAudioWithGetItScreen:
        return MaterialPageRoute(builder: (_) => EditAudioWithGetItScreen(arguments: args));

      case audioDetailsWithGetItScreen:
        return MaterialPageRoute(builder: (_) => AudioDetailsWithGetItScreen(arguments: args));
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