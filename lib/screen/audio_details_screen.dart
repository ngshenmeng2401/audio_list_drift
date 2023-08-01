import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:just_audio/just_audio.dart';

class AudioDetailsScreen extends StatefulWidget {
  final AudioDetailScreenArguments arguments;

  const AudioDetailsScreen({
    Key? key,
    required Object? arguments,
  })  : assert(arguments != null && arguments is AudioDetailScreenArguments),
        this.arguments = arguments as AudioDetailScreenArguments,
        super(key: key);

  @override
  State<AudioDetailsScreen> createState() => _AudioDetailsScreenState();
}

class _AudioDetailsScreenState extends State<AudioDetailsScreen> {
  late AppDb _db;
  AudioEntityData? _audioEntityData;
  final audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool? isPlaying = false;
  final StreamController<AudioEntityData> _audioController =
  StreamController<AudioEntityData>();

  Stream<AudioEntityData> get _audioStream =>
      _audioController.stream;


  @override
  void initState() {
    getAudioData();
    // isPlaying = widget.isPlaying;
    // TODO: implement initState
    // print("widget.playPosition: ${widget.playPosition}");
    super.initState();
  }

  @override
  void dispose() {
    _db.close();
    _audioController.close();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> getAudioData() async {
    _db = AppDb();
    _audioEntityData = await _db.getAudio(widget.arguments.audioId);
    setState(() {
      _audioEntityData = _audioEntityData;
    });
    if (_audioEntityData != null && _audioEntityData!.audioURL != null) {
      await audioPlayer.setUrl(_audioEntityData!.audioURL!);
    }
    if(audioPlayer.duration != null){
      duration = audioPlayer.duration!;
    }

    print("duration $duration");
    setState(() {});
    audioPlayer.positionStream.listen((event) {
      position = event;
      setState(() {
        print("position: $position");
      });
    });
  }

  void navigateToEditAudioScreen(int audioId) async {
    await Navigator.pushNamed(context, AppRouter.editAudioScreen, arguments: audioId)
        .then((value) => () {
              setState(() {
                getAudioData();
              });
            });
    print("d;;test message");
  }

  void playAudio(bool isPlay, int playedPosition) {

    var entity;
    print("isPlaying before action: $isPlaying");
    setState(() {
      if (isPlay) {
        audioPlayer.pause();
        isPlaying = false;
        entity = AudioEntityCompanion(
          audioId: drift.Value(widget.arguments.audioId),
          playPosition: drift.Value(position.inSeconds.toInt()),
          isPlaying: const drift.Value(false),
        );

      } else {
        if(playedPosition != 0){
          audioPlayer.seek(Duration(seconds: playedPosition));
        }
        audioPlayer.play();
        isPlaying = true;
        entity = AudioEntityCompanion(
          audioId: drift.Value(widget.arguments.audioId),
          // playPosition: const drift.Value(0),
          isPlaying: const drift.Value(true),
        );

      }
    });
    print("isPlaying after action: $isPlaying");
    _db.updateAudio(entity);
    // setState(() {
    //   getAudioData();
    // });
    // audioPlayer.onDurationChanged.listen((Duration dd) {
    //   setState(() {
    //     duration = dd;
    //   });
    // });
    // audioPlayer.onPositionChanged.listen((Duration dd) {
    //   setState(() {
    //     position = dd;
    //   });
    // });
  }

  Future<bool> _onWillPop() async {
    widget.arguments.backButtonCallback();
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
    _db.deleteAudio(widget.arguments.audioId);
  }

  Widget _renderAudioSlider(int playedPosition, int totalLength) {

    print("Position: $position");
    return Slider(
        min: 0.0,
        max: totalLength.toDouble(),
        value: position.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            audioPlayer.seek(Duration(seconds: value.toInt()));
          });
        });
  }

  Widget _renderPlayDuration(int played, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            // "0",
            _formatDuration(Duration(seconds: position.inSeconds.toInt())),
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
              child:
              _audioEntityData != null ?
                    Column(
                      children: [
                        Text(
                          _audioEntityData!.audioName!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _renderAudioSlider(_audioEntityData!.playPosition!, _audioEntityData!.totalLength!),
                        const SizedBox(
                          height: 20,
                        ),
                        _renderPlayDuration(_audioEntityData!.playPosition!,
                            _audioEntityData!.totalLength!),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: screenHeight * 0.2,
                          width: screenWidth * 0.2,
                          decoration: const BoxDecoration(
                              color: Colors.blue, shape: BoxShape.circle),
                          child: !isPlaying!
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  onPressed: () {
                                    playAudio(isPlaying!,
                                        _audioEntityData!.playPosition!);
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.pause,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  onPressed: () {
                                    playAudio(isPlaying!,
                                        _audioEntityData!.playPosition!);
                                  },
                                ),
                        ),
                      ],
                    )
                  : Container(),
            )
          ),
        ),
      ),
    );
  }
}

class AudioDetailScreenArguments {
  int audioId;
  final Function() backButtonCallback;

  AudioDetailScreenArguments({required this.audioId, required this.backButtonCallback});
}
