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

class AudioPlayerProviderController extends ChangeNotifier {

  List<AudioPlayHistoryInfo> audioPlayHistoryList = [];
  final audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  int position = 0;
  int currentAudioButtonId = 0;
  int seekPosition = 0;

  var currentPlayingInfo = const CurrentPlayingInfo(
    audioId: -1,
    playerState: AudioPlayerState.stop,
  );

  void playerStream (){
    audioPlayer.positionStream.listen((event) {
      position = event.inSeconds.toInt();
      notifyListeners();
    });
  }

  Future<void> initAudioPlayer() async {
    String audioURL = "https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3";

    try{
      await audioPlayer.setUrl(audioURL);

      if(audioPlayer.duration != null){
        duration = audioPlayer.duration!;
      }
      // audioList = await getIt.get<AppDb>().getAudioList();
      //
      // if(audioList != null){
      //   audioPlayHistoryList.clear();
      //
      //   audioList?.forEach((element) {
      //     audioPlayHistoryList.add(AudioPlayHistoryInfo(element.audioId, 0));
      //   });
      //
      //   audioPlayHistoryList.addAll(audioList?.map((e) {
      //     return AudioPlayHistoryInfo(e.audioId, 0);
      //   }) ?? []);
      //
      //   for (var audioHistory in audioPlayHistoryList) {
      //     print("Audio position history: ${audioHistory.audioId}");
      //   }
      // }
      playerStream ();
      notifyListeners();

    }catch(ex){
      Fimber.e('d;;exception', ex: ex);
    }
  }

  //Just keep for note
  void playAudioButton(
      // void Function(int audioID) onAudioPausing,
      // void Function(int audioID, Duration duration) onAudioPreparing,
      // void Function(int audioID) onAudioPlaying,
      ){

    // 1. pause previous playing audio
    // onAudioPausing(-1);

    // 2. prepare current audio
    // onAudioPreparing(-1, Duration(xxx));

    // 3. play current audio
    // onAudioPlaying(-1);
    notifyListeners();
  }

  void playAudio(AudioPlayerState audioPlayerState, String audioURL, int audioId) {
    print("Current Audio Id: $currentAudioButtonId");
    print("Audio Id: $audioId");

    try {
      //to save the latest audio player position
      // for (var audioHistory in audioPlayHistoryList) {
      //   if(audioHistory.audioId == currentAudioButtonId) {
      //     audioHistory.pauseAt = position;
      //   }
      // }

      if (audioId == currentAudioButtonId) {
        if (audioPlayerState == AudioPlayerState.pause) {
          duration = audioPlayer.duration!;
           audioPlayer.pause();
          currentPlayingInfo = CurrentPlayingInfo(
            audioId: currentAudioButtonId,
            playerState: AudioPlayerState.pause,
          );
        } else if (audioPlayerState == AudioPlayerState.play) {
          currentPlayingInfo = CurrentPlayingInfo(
            audioId: currentAudioButtonId,
            playerState: AudioPlayerState.play,
          );
          if (position == 0) {
            audioPlayer.setUrl(audioURL);
          }
            audioPlayer.play();
          // if(audioPlayer.duration != null){
            duration = audioPlayer.duration!;
          // }
        }
      } else {
        currentPlayingInfo = CurrentPlayingInfo(
          audioId: audioId,
          playerState: AudioPlayerState.play,
        );
        currentAudioButtonId = audioId;
         audioPlayer.setUrl(audioURL);
        // for (var audioHistory in audioPlayHistoryList) {
        //   if(audioHistory.audioId == audioId){
        //     seekPosition = audioHistory.pauseAt;
        //   }
        // }
        // await audioPlayer.seek(Duration(seconds: seekPosition == duration.inSeconds ? 0 : seekPosition));
         audioPlayer.play();
        duration = audioPlayer.duration!;
        // await Future.delayed(const Duration(milliseconds: 500));

        // print("After Audio Player State: $audioPlayerState");
        // print("Current Playing Info: ${currentPlayingInfo.playerState}");
      }
      // print("Audio position history:");
      // for (var audioHistory in audioPlayHistoryList) {
      //   print("${audioHistory.audioId}: ${audioHistory.pauseAt}");
      // }
      notifyListeners();
      print("duration songs: $duration ");
    } catch (ex) {
      ("Audio Player $ex");
    }
  }

  void updateButtonSongsEnd(int audioId, int totalLength){
    // print("audioId: $audioId");
    // print("position: $position");
    if(position == totalLength){
      currentPlayingInfo = CurrentPlayingInfo(
        audioId: audioId,
        playerState: AudioPlayerState.pause,
      );
      position = 0;
    }
    return;
    // notifyListeners();
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }
}
