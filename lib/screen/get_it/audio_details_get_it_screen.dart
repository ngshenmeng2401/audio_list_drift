import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_player_controller.dart';
import 'package:audio_player_list_with_drift/screen/get_it/edit_audio_get_it_screen.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:get_it/get_it.dart';

class AudioDetailsWithGetItScreen extends StatefulWidget {
  final AudioDetailWithGetItScreenArguments arguments;

  const AudioDetailsWithGetItScreen({
    Key? key,
    required Object? arguments,
  })  : assert(arguments != null &&
            arguments is AudioDetailWithGetItScreenArguments),
        this.arguments = arguments as AudioDetailWithGetItScreenArguments,
        super(key: key);

  @override
  State<AudioDetailsWithGetItScreen> createState() =>
      _AudioDetailsWithGetItScreenState();
}

class _AudioDetailsWithGetItScreenState
    extends State<AudioDetailsWithGetItScreen> {
  AudioEntityData? _audioEntityData;
  final StreamController<AudioEntityData> _audioController =
      StreamController<AudioEntityData>();

  Stream<AudioEntityData> get _audioStream => _audioController.stream;

  final GetIt getIt = GetIt.instance;
  late AudioPlayerController audioPlayerController;

  @override
  void initState() {
    getAudioData();
    setState(() {
    });
    // audioPlayerController.buttonControllerStream.sink.add(false);
    super.initState();
    audioPlayerController = getIt.get<AudioPlayerController>();
  }

  @override
  void dispose() {
    _audioController.close();
    // audioPlayerController.audioPlayer.dispose();
    super.dispose();
  }

  Future<void> getAudioData() async {
    try {
      _audioEntityData =
          await getIt.get<AppDb>().getAudio(widget.arguments.audioId);
      setState(() {
        _audioEntityData = _audioEntityData;
      });

      if (_audioEntityData != null) {
        _audioController.sink.add(_audioEntityData!);
        if (_audioEntityData!.audioURL != null) {
          await audioPlayerController.audioPlayer
              .setUrl(_audioEntityData!.audioURL!);
        }
      }
      if (audioPlayerController.audioPlayer.duration != null) {
        audioPlayerController.duration =
            audioPlayerController.audioPlayer.duration!;
      }
    } catch (ex) {
      Fimber.e('d;;exception', ex: ex);
    }

    print("duration ${audioPlayerController.duration}");
    setState(() {});
    audioPlayerController.audioPlayer.positionStream.listen((event) {
      audioPlayerController.position = event;
      setState(() {
        print("position: ${audioPlayerController.position}");
      });
    });
  }

  void navigateToEditAudioScreen(int audioId) async {
    await Navigator.pushNamed(context, AppRouter.editAudioWithGetItScreen,
        arguments: EditAudioWithGetItScreenArguments(
            audioId: audioId, backButtonCallback: getAudioData));
  }

  Future<void> showDeleteAudioDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Audio'),
          content: const Text(
            'Are you sure want to delete this audio ?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteAudio();
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteAudio() {
    getIt.get<AppDb>().deleteAudio(widget.arguments.audioId);
  }

  Widget _renderAudioSlider(int playedPosition, int totalLength) {
    print("Position: ${audioPlayerController.position}");
    return Slider(
        min: 0.0,
        max: audioPlayerController.duration.inSeconds.toDouble(),
        value: audioPlayerController.position.inSeconds.toDouble() ==
                audioPlayerController.duration.inSeconds.toDouble()
            ? 0
            : audioPlayerController.position.inSeconds.toDouble(),
        onChanged: (double value) {
          // audioPlayerController.audioPlayer
          //     .seek(Duration(seconds: value.toInt()));
        });
  }

  Widget _renderPlayDuration(int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          audioPlayerController.position.inSeconds.toDouble() ==
                  audioPlayerController.duration.inSeconds.toDouble()
              ? Text(
                  _formatDuration(const Duration(seconds: 0)),
                  style: const TextStyle(fontSize: 16),
                )
              : Text(
                  // "0",
                  _formatDuration(Duration(
                      seconds:
                          audioPlayerController.position.inSeconds.toInt())),
                  style: const TextStyle(fontSize: 16),
                ),
          Text(
            // "0",
            _formatDuration(Duration(seconds: total)),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String playedMinutesString =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String playedSecondsString =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$playedMinutesString:$playedSecondsString';
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Details"),
        actions: [
          IconButton(
              onPressed: () {
                navigateToEditAudioScreen(widget.arguments.audioId);
              },
              icon: const Icon(Icons.edit_outlined)),
          // IconButton(onPressed: () {
          //   showDeleteAudioDialog(context);
          // }, icon: const Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: StreamBuilder(
                    stream: _audioStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Text(
                              snapshot.data!.audioName!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _renderAudioSlider(snapshot.data!.playPosition!,
                                snapshot.data!.totalLength!),
                            const SizedBox(
                              height: 20,
                            ),
                            _renderPlayDuration(snapshot.data!.totalLength!),
                            const SizedBox(
                              height: 20,
                            ),
                            ValueListenableBuilder<CurrentPlayingInfo>(
                              valueListenable:
                              audioPlayerController.currentPlayingInfo,
                              builder: (context, value, child) {
                                var iconData = Icons.play_arrow;

                                if (value.audioId == widget.arguments.audioId) {
                                  iconData = value.playerState == AudioPlayerState.play ? Icons.pause : Icons.play_arrow;
                                }

                                return Container(
                                  height: screenHeight * 0.2,
                                  width: screenWidth * 0.2,
                                  decoration: const BoxDecoration(
                                      color: Colors.blue, shape: BoxShape.circle),
                                  child: IconButton(
                                    icon: Icon(
                                      iconData,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    onPressed: () {
                                      audioPlayerController.currentPlayingInfo.value =
                                          CurrentPlayingInfo(
                                            audioId: widget.arguments.audioId,
                                            playerState: value.playerState == AudioPlayerState.play ? AudioPlayerState.pause : AudioPlayerState.play,
                                          );
                                    },
                                  ),
                                );
                              },
                            ),
                          //   Container(
                          //     height: screenHeight * 0.2,
                          //     width: screenWidth * 0.2,
                          //     decoration: const BoxDecoration(
                          //         color: Colors.blue, shape: BoxShape.circle),
                          //     child: !audioPlayerController.isPlaying! ||
                          //             audioPlayerController.position.inSeconds
                          //                     .toDouble() ==
                          //                 audioPlayerController
                          //                     .duration.inSeconds
                          //                     .toDouble()
                          //         ? IconButton(
                          //             icon: const Icon(
                          //               Icons.play_arrow,
                          //               color: Colors.white,
                          //               size: 50,
                          //             ),
                          //             onPressed: () {
                          //               setState(() {
                          //                 audioPlayerController.playAudio(
                          //                   audioPlayerController.isPlaying!,
                          //                   snapshot.data!.playPosition!,
                          //                   widget.arguments.index,
                          //                 );
                          //               });
                          //             },
                          //           )
                          //         : IconButton(
                          //             icon: const Icon(
                          //               Icons.pause,
                          //               color: Colors.white,
                          //               size: 50,
                          //             ),
                          //             onPressed: () {
                          //               setState(() {
                          //                 audioPlayerController.playAudio(
                          //                   audioPlayerController.isPlaying!,
                          //                   snapshot.data!.playPosition!,
                          //                   widget.arguments.index,
                          //                 );
                          //               });
                          //             },
                          //           ),
                          //   ),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return const Text("No data");
                    })
                ))
      ),
    );
  }
}

class AudioDetailWithGetItScreenArguments {
  int audioId;

  AudioDetailWithGetItScreenArguments(
      {required this.audioId,});
}
