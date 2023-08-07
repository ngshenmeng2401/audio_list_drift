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
  List<int> audioPositionList = [];
  // List<int> testList = [];
  final audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  // Duration position = const Duration();
  int position = 0;
  int currentIndexAudioButton = 0;
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
    audioPositionList.clear();
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
        for(int i = 0 ; i < audioList!.length ; i++){
          audioPositionList.insert( i, 0);

        }
        print("Current Audio Position List: $audioPositionList");
      }

    }catch(ex){
      Fimber.e('d;;exception', ex: ex);
    }
  }

  Future<void> playAudioList(AudioPlayerState audioPlayerState, String audioURL, int audioPlayerIndex) async {
    print("Current Player Index: $currentIndexAudioButton");
    print("Audio Player Index: $audioPlayerIndex");
    // print("Before Audio Player State: $audioPlayerState");

    try {
      //to save the latest audio player position
      audioPositionList[currentIndexAudioButton] = position;

      if (audioPlayerIndex == currentIndexAudioButton) {
        print("hihi1");
        if (audioPlayerState == AudioPlayerState.pause) {
          print("hihi2");
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
        print("hihi3");
        currentIndexAudioButton = audioPlayerIndex;
        await audioPlayer.setUrl(audioURL);
        seekPosition =  audioPositionList[audioPlayerIndex];
        await audioPlayer.seek(Duration(seconds: seekPosition == duration.inSeconds ? 0 : seekPosition));
        await audioPlayer.play();
        duration = audioPlayer.duration!;
        // await Future.delayed(const Duration(milliseconds: 500));
        currentPlayingInfo.value = currentPlayingInfo.value.copyWith(
          playerState: AudioPlayerState.play,
        );

      }
      print("Audio Position List: {$audioPositionList}");
      // print("duration songs: $duration ");
      print("After Audio Player State: $audioPlayerState");
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

  void addAudioPositionList(){

    audioPositionList.add(0);
    print("New Audio Position List Added: $audioPositionList");
  }

  void removeAudioPositionList(int index){

    audioPositionList.removeAt(index);
    print("New Audio Position List Removed: $audioPositionList");
    //to prevent the new audio use old seek position when add audio
    seekPosition = 0;
    //to prevent the next audio is not playing when delete the playing audio
    currentIndexAudioButton = 0;
  }
}
