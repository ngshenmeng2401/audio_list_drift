import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class AudioPlayerProviderController {

  final audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();

  final _playerState = AudioPlayerState.stop;
  AudioPlayerState get playerState => _playerState;

  IconData _iconData = Icons.play_arrow;
  IconData get iconData => _iconData;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  final currentPlayingInfo = ValueNotifier<CurrentPlayingInfo>(
    CurrentPlayingInfo(
      audioId: -1,
      playerState: AudioPlayerState.stop,
    ),
  );

  void playAudioButton(){

    print("Bool: $_isPlaying");
    if(!_isPlaying){
      _iconData = Icons.pause;
      _isPlaying = true;
    }else{
      _iconData = Icons.play_arrow;
      _isPlaying = false;
    }
    // notifyListeners();
  }
}