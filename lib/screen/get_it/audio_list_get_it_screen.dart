import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_list_controller.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_player_controller.dart';
import 'package:audio_player_list_with_drift/screen/get_it/add_audio_get_it_screen.dart';
import 'package:audio_player_list_with_drift/screen/get_it/audio_details_get_it_screen.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:get_it/get_it.dart';

class AudioListWithGetItScreen extends StatefulWidget {
  const AudioListWithGetItScreen({super.key});

  @override
  State<AudioListWithGetItScreen> createState() => _AudioListWithGetItScreenState();
}

class _AudioListWithGetItScreenState extends State<AudioListWithGetItScreen> {
  final audioListController = GetIt.instance.get<AudioListController>();
  final AudioPlayerController audioPlayerController = GetIt.instance.get<AudioPlayerController>();

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioListController.refreshAudioList();

    setState(() {});
    audioPlayerController.audioPlayer.positionStream.listen((event) {
      audioPlayerController.position = event;
      setState(() {
        print("position: ${audioPlayerController.position}");
      });
    });
  }

  @override
  void dispose() {
    audioListController.dispose();
    audioPlayerController.dispose();
    super.dispose();
  }

  Future<void> showDeleteAudioDialog(BuildContext context, int audioId) {
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
                _deleteAudio(audioId);
                Navigator.of(context).pop();
                // setState(() {
                getIt.get<AppDb>().getAudioList();
                // });
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAudio(int audioId) {
    getIt.get<AppDb>().deleteAudio(audioId);

    audioListController.getAudioListData();
  }

  String _formatDuration(Duration duration) {
    String playedMinutesString = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String playedSecondsString = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$playedMinutesString:$playedSecondsString';
  }

  void navigateToAddAudioScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRouter.addAudioWithGetItScreen, arguments: AddAudioWithGetItScreenArguments(backButtonCallback: audioListController.getAudioListData));
  }

  void navigateToAudioDetailsScreen(int audioId, int index, String audioURL) async {
    Navigator.pushNamed(context, AppRouter.audioDetailsWithGetItScreen,
        arguments: AudioDetailWithGetItScreenArguments(
          audioId: audioId,
        ));
  }

  Widget _renderPlayDuration(int total, AudioPlayerState audioPlayerState) {
    if (audioPlayerState != AudioPlayerState.play) {
      return Row(
        children: [
          audioPlayerController.position.inSeconds.toDouble() == audioPlayerController.duration.inSeconds.toDouble()
              ? Text(
                  _formatDuration(const Duration(seconds: 0)),
                  style: const TextStyle(fontSize: 14),
                )
              : Text(
                  _formatDuration(Duration(seconds: audioPlayerController.position.inSeconds.toInt())),
                  style: const TextStyle(fontSize: 14),
                ),
          const SizedBox(
            width: 5,
          ),
          const Text(
            "-",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            _formatDuration(Duration(seconds: total)),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      );
    }
    return Text(
      _formatDuration(Duration(seconds: total)),
      style: const TextStyle(fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio List"),
        actions: [
          IconButton(
              onPressed: () {
                navigateToAddAudioScreen(context);
              },
              icon: const Icon(Icons.add_circle_rounded))
        ],
      ),
      body: StreamBuilder<List<AudioEntityData>>(
          stream: audioListController.audioListStream,
          builder: (context, AsyncSnapshot<List<AudioEntityData>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            navigateToAudioDetailsScreen(snapshot.data![index].audioId, index, snapshot.data![index].audioURL!);
                          },
                          onLongPress: () {
                            showDeleteAudioDialog(context, snapshot.data![index].audioId);
                          },
                          title: Text(snapshot.data![index].audioName!),
                          subtitle: ValueListenableBuilder<CurrentPlayingInfo>(
                              valueListenable: audioPlayerController.currentPlayingInfo,
                              builder: (context, value, child) {
                                var audioPlayerState = AudioPlayerState.play;

                                if (value.audioId == snapshot.data![index].audioId) {
                                  audioPlayerState = value.playerState == AudioPlayerState.play ? AudioPlayerState.pause : AudioPlayerState.play;
                                }
                                return _renderPlayDuration(snapshot.data![index].totalLength!, audioPlayerState);
                              }),
                          trailing: Container(
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(50)),
                            child: ValueListenableBuilder<CurrentPlayingInfo>(
                              valueListenable: audioPlayerController.currentPlayingInfo,
                              builder: (context, iconValue, child) {
                                var iconData = Icons.play_arrow;

                                if (iconValue.audioId == snapshot.data![index].audioId) {
                                  iconData = iconValue.playerState == AudioPlayerState.play ? Icons.pause : Icons.play_arrow;
                                }

                                return IconButton(
                                  icon: Icon(
                                    color: Colors.white,
                                    iconData,
                                  ),
                                  onPressed: () {
                                    audioPlayerController.currentPlayingInfo.value = CurrentPlayingInfo(
                                      audioId: snapshot.data![index].audioId,
                                      playerState: iconValue.playerState == AudioPlayerState.play ? AudioPlayerState.pause : AudioPlayerState.play,
                                    );
                                    // audioPlayerController.audioIdControllerStream.sink.add(snapshot.data![index].audioId);
                                    // setState(() {
                                    //   audioPlayerController.playAudioList(
                                    //     audioPlayerController
                                    //         .isPlayedList[index],
                                    //     index,
                                    //   );
                                    // });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: Text("No data"));
            }
          }),
    );
  }
}
