import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:just_audio/just_audio.dart';

enum AudioPlayerState { play, pause, stop }

class CurrentPlayingInfo {
  int audioId;
  AudioPlayerState playerState;

  CurrentPlayingInfo({
    required this.audioId,
    required this.playerState,
  });

  CurrentPlayingInfo copyWith({int? audioId, AudioPlayerState? playerState}) => CurrentPlayingInfo(audioId: audioId ?? this.audioId, playerState: playerState ?? this.playerState);
}

class AudioPlayerController {
  List<AudioEntityData>? audioList;
  // List<Duration> currentAudioPositionList = [];
  List<int> currentAudioPositionList = [];
  final audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  // Duration position = const Duration();
  int position = 0;
  int currentIndexAudioButton = 0;

  final currentPlayingInfo = ValueNotifier<CurrentPlayingInfo>(
    CurrentPlayingInfo(
      audioId: -1,
      playerState: AudioPlayerState.stop,
    ),
  );

  // StreamSubscription? _subscription;

  AudioPlayerController() {
    // _subscription = _audioIdControllerStream.stream.listen((event) {
    //   currentPlayingInfo.value = event;
    // });
  }

  void setAudioPlayerState(int audioId, AudioPlayerState state) {
    // _audioIdControllerStream.sink.add(CurrentPlayingInfo(
    //   audioId: audioId,
    //   playerState: state,
    // ));
    currentPlayingInfo.value = CurrentPlayingInfo(
      audioId: audioId,
      playerState: state,
    );
  }

  void dispose() {
    // _subscription?.cancel();
    currentPlayingInfo.dispose();
  }

  Future<void> initAudioPlayer() async {
    String audioURL = "https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3";

    try{
      await audioPlayer.setUrl(audioURL);

      if(audioPlayer.duration != null){
        duration = audioPlayer.duration!;
      }

      if(currentAudioPositionList != null){
        currentAudioPositionList!.clear();
      }
      audioList = await getIt.get<AppDb>().getAudioList();

      if(audioList != null){
        print("audioList: ${audioList!.length}");
        for(int i = 0 ; i < audioList!.length ; i++){
          currentAudioPositionList!.insert( i, 0);
          print("Current Audio Position List: ${currentAudioPositionList![i]}");
        }

      }

    }catch(ex){
      Fimber.e('d;;exception', ex: ex);
    }
  }

  Future<void> playAudioList(AudioPlayerState audioPlayerState, String audioURL, int audioPlayerIndex) async {
    // print("Current Player Index: $currentIndexAudioButton");
    print("Audio Player Index: $audioPlayerIndex");
    // print("Before Audio Player State: $audioPlayerState");

    try {
      if (audioPlayerIndex == currentIndexAudioButton) {
        if (audioPlayerState == AudioPlayerState.pause) {
          await audioPlayer.pause();
          currentPlayingInfo.value = currentPlayingInfo.value.copyWith(
            playerState: AudioPlayerState.pause,
          );
        } else if (audioPlayerState == AudioPlayerState.play) {
          // currentPlayingInfo.value = currentPlayingInfo.value.copyWith(
          //   playerState: AudioPlayerState.play,
          // );
          if (position == 0) {
            await audioPlayer.setUrl(audioURL);
          }
          await audioPlayer.play();
          if(audioPlayer.duration != null){
            duration = audioPlayer.duration!;
          }
        }
        // switch (audioPlayerState) {
        //   case AudioPlayerState.pause:
        //     await audioPlayer.pause();
        //     currentPlayingInfo.value = currentPlayingInfo.value.copyWith(
        //       playerState: AudioPlayerState.pause,
        //     );
        //     break;
        //   case AudioPlayerState.play:
        //     // audioPlayer.setUrl(audioURL);
        //     await audioPlayer.play();
        //     break;
        //   default:
        //     await audioPlayer.stop();
        // }
      } else {
        currentPlayingInfo.value = currentPlayingInfo.value.copyWith(
          playerState: AudioPlayerState.play,
        );

        currentIndexAudioButton = audioPlayerIndex;
        await audioPlayer.setUrl(audioURL);
        await audioPlayer.seek(Duration(seconds: position)).then((value) => print('Succeeded')).onError((error, stackTrace) => print('Failed'));
        await audioPlayer.play();
        duration = audioPlayer.duration!;

      }
      // print("duration songs: $duration ");
      // print("After Audio Player State: $audioPlayerState");
    } catch (ex) {
      ("Audio Player $ex");
    }
  }

  void updateButtonSongsEnd(){
    // print("Position in updateButtonSongsEnd: ${position.inSeconds}");
    // print("Duration in updateButtonSongsEnd: ${duration.inSeconds}");
    currentPlayingInfo.value = currentPlayingInfo.value.copyWith(
      playerState: AudioPlayerState.pause,
    );
    position = 0;
  }
}
