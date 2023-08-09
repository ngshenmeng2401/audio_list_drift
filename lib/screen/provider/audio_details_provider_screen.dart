import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_player_provider_controller.dart';
import 'package:audio_player_list_with_drift/screen/provider/edit_audio_provider_screen.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class AudioDetailsWithProviderScreen extends StatefulWidget {
  final AudioDetailWithProviderScreenArguments arguments;

  const AudioDetailsWithProviderScreen({
    Key? key,
    required Object? arguments,
  })  : assert(arguments != null && arguments is AudioDetailWithProviderScreenArguments),
        this.arguments = arguments as AudioDetailWithProviderScreenArguments,
        super(key: key);

  @override
  State<AudioDetailsWithProviderScreen> createState() => _AudioDetailsWithProviderScreenState();
}

class _AudioDetailsWithProviderScreenState extends State<AudioDetailsWithProviderScreen> {
  AudioEntityData? _audioEntityData;
  final StreamController<AudioEntityData> _audioController =
      StreamController<AudioEntityData>();

  Stream<AudioEntityData> get _audioStream => _audioController.stream;

  AudioPlayerProviderController? _audioPlayerProviderController;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getAudioData();
    Provider.of<AudioPlayerProviderController>(context, listen: false).playerStream();
    // setState(() {});
    // Provider.of<AudioPlayerProviderController>(context, listen: false).audioPlayer.positionStream.listen((event) {
    //   Provider.of<AudioPlayerProviderController>(context, listen: false).position = event.inSeconds.toInt();
    //   setState(() {
    //     // print("position: ${audioPlayerController.position}");
    //   });
    // });
  }

  @override
  void dispose() {
    _audioController.close();
    super.dispose();
  }

  Future<void> getAudioData() async {
    try {
      _audioEntityData = await Provider.of<AppDb>(context, listen: false)
          .getAudio(widget.arguments.audioId);
      setState(() {
        _audioEntityData = _audioEntityData;
      });

      if (_audioEntityData != null) {
        _audioController.sink.add(_audioEntityData!);
      }

    } catch (ex) {
      Fimber.e('d;;exception', ex: ex);
    }
  }

  void navigateToEditAudioScreen(int audioId) async {
    await Navigator.pushNamed(context, AppRouter.editAudioWithProviderScreen,
            arguments: EditAudioWithProviderScreenArguments(
                audioId: audioId, backButtonCallback: getAudioData));
  }

  Future<bool> _onWillPop() async {
    // widget.arguments.backButtonCallback();
    return true;
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
    Provider.of<AppDb>(context).deleteAudio(widget.arguments.audioId);
  }

  Widget _renderAudioSlider(AudioPlayerState audioPlayerState, int totalLength) {

    final audioPlayerController = Provider.of<AudioPlayerProviderController>(context, listen: false);

    if(audioPlayerController.currentAudioButtonId == widget.arguments.audioId && audioPlayerState != AudioPlayerState.stop){
      return Selector<AudioPlayerProviderController, int>(
          selector: (context, controller) => controller.position,
          builder: (BuildContext context, position, Widget? child) {
            return Slider(
                min: 0.0,
                max: totalLength.toDouble(),
                value: position.toDouble() == totalLength.toDouble() ? 0 : position.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    Provider.of<AudioPlayerProviderController>(context, listen: false).audioPlayer.seek(Duration(seconds: value.toInt()));
                  });
                });
          }
      );
      // return Consumer<AudioPlayerProviderController>(
      //     builder: (BuildContext context, audioPlayerProviderController, Widget? child) {
      //       return Slider(
      //           min: 0.0,
      //           max: totalLength.toDouble(),
      //           value: audioPlayerProviderController.position.toDouble() == totalLength.toDouble() ? 0 : audioPlayerProviderController.position.toDouble(),
      //           onChanged: (double value) {
      //             setState(() {
      //               Provider.of<AudioPlayerProviderController>(context, listen: false).audioPlayer.seek(Duration(seconds: value.toInt()));
      //             });
      //           });
      //     }
      // );
    }
    return Slider(
        min: 0.0,
        max: totalLength.toDouble(),
        value: 0,
        onChanged: null
    );
  }

  Widget _renderPlayDuration(int total) {

    final audioPlayerController = Provider.of<AudioPlayerProviderController>(context, listen: false);

    return Selector<AudioPlayerProviderController, int>(
        selector: (context, controller) => controller.position,
        builder: (BuildContext context, position, Widget? child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(audioPlayerController.currentAudioButtonId != widget.arguments.audioId || audioPlayerController.position == audioPlayerController.duration.inSeconds.toDouble())...{
                Text(
                  _formatDuration(const Duration(seconds: 0)),
                  style: const TextStyle(fontSize: 16),
                )
              } else...{
                Text(
                  // "0",
                  _formatDuration(Duration(seconds: position)),
                  style: const TextStyle(fontSize: 16),
                ),
              },
              Text(
                // "0",
                _formatDuration(Duration(seconds: total)),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }
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

    // _audioPlayerProviderController ??= context.watch<AudioPlayerProviderController>();
    // _audioPlayerProviderController = Provider.of<AudioPlayerProviderController>(context, listen: false);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                              Selector<AudioPlayerProviderController, CurrentPlayingInfo>(
                                  selector: (context, controller) => controller.currentPlayingInfo,
                                  builder: (BuildContext context, info, Widget? child) {
                                    var audioPlayerState = AudioPlayerState.play;

                                    if (info.audioId == snapshot.data!.audioId) {
                                      if(info.playerState == AudioPlayerState.play){
                                        AudioPlayerState.pause;
                                      }
                                      audioPlayerState = info.playerState == AudioPlayerState.play ? AudioPlayerState.pause : AudioPlayerState.play;


                                    }
                                  return _renderAudioSlider(
                                      audioPlayerState,
                                      snapshot.data!.totalLength!);
                                }
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              _renderPlayDuration(snapshot.data!.totalLength!),
                              const SizedBox(
                                height: 20,
                              ),
                              Selector<AudioPlayerProviderController, CurrentPlayingInfo>(
                                selector: (context, controller) => controller.currentPlayingInfo,
                                builder: (BuildContext context, info, Widget? child) {
                                  var iconData = Icons.play_arrow;
                                  var audioPlayerState = AudioPlayerState.play;

                                  if (info.audioId == snapshot.data!.audioId) {
                                    if(info.playerState == AudioPlayerState.play){
                                      AudioPlayerState.pause;
                                    }
                                    iconData = info.playerState == AudioPlayerState.play ? Icons.pause : Icons.play_arrow;
                                    audioPlayerState = info.playerState == AudioPlayerState.play ? AudioPlayerState.pause : AudioPlayerState.play;

                                  }
                                  return Container(
                                      height: screenHeight * 0.2,
                                      width: screenWidth * 0.2,
                                      decoration: const BoxDecoration(
                                          color: Colors.blue, shape: BoxShape.circle),
                                      child: IconButton(
                                        icon: Icon(
                                          size: 50,
                                          color: Colors.white,
                                          iconData,
                                        ),
                                        onPressed: () {
                                          // print("Bool: ${controller.isPlaying}");
                                          context.read<AudioPlayerProviderController>().playAudio(audioPlayerState, snapshot.data!.audioURL!, snapshot.data!.audioId!);
                                        },
                                      ));
                                },
                              )
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
                  // : Container(),
                  )),
        ),
      ),
    );
  }
}

class AudioDetailWithProviderScreenArguments {
  int audioId;
  // final Function() backButtonCallback;

  AudioDetailWithProviderScreenArguments(
      {required this.audioId});
}
