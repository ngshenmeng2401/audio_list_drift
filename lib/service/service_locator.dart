
import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_controller.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {

  getIt.registerLazySingleton<AppDb>(() => AppDb());
  
  getIt.registerLazySingleton<AudioController>(() => AudioController());
}