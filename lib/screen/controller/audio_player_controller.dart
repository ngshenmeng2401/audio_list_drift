import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:just_audio/just_audio.dart';

enum AudioPlayerState { play, pause, stop }

class AudioPlayerController {

  final StreamController<int> audioIdControllerStream =
    StreamController<int>.broadcast();

  Stream<int> get audioIdStream => audioIdControllerStream.stream;

  AudioPlayerController(){
    print("Constructor init");
  }

// List<AudioEntityData>? audioList;
  //
  // List<bool> isPlayedList = [];
  // bool? isPlaying = false;
  // final audioPlayer = AudioPlayer();
  // Duration duration = const Duration();
  // Duration position = const Duration();
  // bool? buttonPlay = false;
  //
  // final StreamController<bool> buttonControllerStream =
  //     StreamController<bool>.broadcast();
  //
  // Stream<bool> get buttonStream => buttonControllerStream.stream;
  //
  // void initAudioPlayer(String audioURL) {
  //   audioPlayer.setUrl(audioURL);
  //   print(audioURL);
  //   audioPositionStream();
  // }
  //
  // void audioPositionStream() {
  //   audioPlayer.positionStream.listen((event) {
  //     if (event != null) {
  //       Duration temp = event;
  //       position = temp;
  //     }
  //   });
  // }
  //
  // Future<void> initPlayButtonList() async {
  //   try {
  //     print("Audio List before clear: $audioList");
  //
  //     if(isPlayedList != null){
  //       isPlayedList.clear();
  //     }
  //
  //     if (audioList != null) {
  //       audioList!.clear();
  //     }
  //     audioList = await getIt.get<AppDb>().getAudioList();
  //
  //     if (audioList != null) {
  //       for (int i = 0; i < audioList!.length; i++) {
  //         isPlayedList.insert(i, false);
  //       }
  //     }
  //
  //     print("Audio List after get data: $audioList");
  //   } catch (ex) {
  //     Fimber.e('d;;exception', ex: ex);
  //   }
  // }
  //
  // void playAudioList(bool isPlayed, int index) {
  //   audioPlayer.setUrl(audioList![index].audioURL!);
  //
  //   print("isPlayed: $isPlayed");
  //
  //   if (isPlayed == true) {
  //     audioPlayer.pause();
  //     isPlayedList[index] = false;
  //   } else {
  //     // audioPlayer.seek(Duration(seconds: position.inSeconds.toInt()));
  //     audioPlayer.play();
  //     isPlayedList[index] = true;
  //   }
  // }
  //
  // void playAudio(bool isPlayed, int audioId, int index) {
  //   if (isPlayed == true) {
  //     audioPlayer.pause();
  //     isPlaying = false;
  //   } else {
  //     audioPlayer.play();
  //     isPlaying = true;
  //   }
  // }
  //
  // void testPlayButton(bool isPlay){
  //
  //   print("d;;isPlay $isPlay");
  //
  //   if(isPlay == false){
  //     buttonPlay = true;
  //     buttonControllerStream.sink.add(buttonPlay!);
  //   }else{
  //     buttonPlay = false;
  //     buttonControllerStream.sink.add(buttonPlay!);
  //   }
  //
  // }
}
