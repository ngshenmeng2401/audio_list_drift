import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:just_audio/just_audio.dart';

enum AudioPlayerState { play, pause, stop }

class CurrentPlayingInfo {
  final int audioId;
  final AudioPlayerState playerState;

  const CurrentPlayingInfo({
    required this.audioId,
    required this.playerState,
  });

   CurrentPlayingInfo copyWith({int? audioId, AudioPlayerState? playerState}) => CurrentPlayingInfo(audioId: audioId ?? this.audioId, playerState: playerState ?? this.playerState);
}

class AudioPlayHistoryInfo {
   int audioId;
   int pauseAt;

   AudioPlayHistoryInfo(this.audioId, this.pauseAt);
}

class AudioPlayerController {
  List<AudioEntityData> audioList = [];
  List<AudioPlayHistoryInfo> audioPlayHistoryList = [];
  final audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  int position = 0;
  int currentAudioButtonId = 0;
  int seekPosition = 0;

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
    audioPlayHistoryList.clear();
  }

  Future<void> initAudioPlayer() async {
    String audioURL = "https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3";

    try{
      await audioPlayer.setUrl(audioURL);

      if(audioPlayer.duration != null){
        duration = audioPlayer.duration!;
      }
      audioList = await getIt.get<AppDb>().getAudioList();

      if(audioList != null){
        // print("audioList: ${audioList!.length}");
        audioPlayHistoryList.clear();

        // audioList?.forEach((element) {
        //   audioPlayHistoryList.add(AudioPlayHistoryInfo(element.audioId, 0));
        // });

        audioPlayHistoryList.addAll(audioList?.map((e) {
          return AudioPlayHistoryInfo(e.audioId, 0);
        }) ?? []);

        for (var audioHistory in audioPlayHistoryList) {
          print("Audio position history: ${audioHistory.audioId}");
        }

        // final info = audioPlayHistoryList.firstWhere<>((element) => element.audioId == 1, orElse: null);
        // audioPlayHistoryList.firstWhere((element) => false)
        // audioPlayHistoryList[index].pauseAt = 1;


      }

    }catch(ex){
      Fimber.e('d;;exception', ex: ex);
    }
  }

  Future<void> playAudio(AudioPlayerState audioPlayerState, String audioURL, int audioId) async {
    print("Current Audio Id: $currentAudioButtonId");
    print("Audio Id: $audioId");

    try {
      //to save the latest audio player position
      for (var audioHistory in audioPlayHistoryList) {
        if(audioHistory.audioId == currentAudioButtonId) {
          audioHistory.pauseAt = position;
        }
      }
      // for(int i = 0 ; i < audioPlayHistoryList!.length ; i++){
      //   audioPlayHistoryList[i].audioId == audioId;
      //   audioPlayHistoryList.re
      //   break;
      // }
      // audioPositionList[currentIndexAudioButton] = position;

      if (audioId == currentAudioButtonId) {
        if (audioPlayerState == AudioPlayerState.pause) {
          await audioPlayer.pause();
          currentPlayingInfo.value = currentPlayingInfo.value.copyWith(
            playerState: AudioPlayerState.pause,
          );
        } else if (audioPlayerState == AudioPlayerState.play) {

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
        currentAudioButtonId = audioId;
        await audioPlayer.setUrl(audioURL);
        for (var audioHistory in audioPlayHistoryList) {
          if(audioHistory.audioId == audioId){
            seekPosition = audioHistory.pauseAt;
          }
        }
        await audioPlayer.seek(Duration(seconds: seekPosition == duration.inSeconds ? 0 : seekPosition));
        await audioPlayer.play();
        duration = audioPlayer.duration!;
        // await Future.delayed(const Duration(milliseconds: 500));
        currentPlayingInfo.value = currentPlayingInfo.value.copyWith(
          playerState: AudioPlayerState.play,
        );

      }
      print("Audio position history:");
      for (var audioHistory in audioPlayHistoryList) {
        print("${audioHistory.audioId}: ${audioHistory.pauseAt}");
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

  void addAudioPositionList(int audioId){

    audioPlayHistoryList.add(AudioPlayHistoryInfo(audioId, 0));
    print("New Audio Position List Added:");
    for (var audioHistory in audioPlayHistoryList) {
      print("${audioHistory.audioId}: ${audioHistory.pauseAt}");
    }
  }

  void removeAudioPositionList(int audioId){

    audioPlayHistoryList.removeAt(audioId);
    print("New Audio Position List Removed: $audioPlayHistoryList");
    print("New Audio Position List Removed:");
    for (var audioHistory in audioPlayHistoryList) {
      print("${audioHistory.audioId}: ${audioHistory.pauseAt}");
    }
    //to prevent the new audio use old seek position when add audio
    seekPosition = 0;
    //to prevent the next audio is not playing when delete the playing audio
    currentAudioButtonId = 0;
  }
}
