import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_list_provider_controller.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_player_provider_controller.dart';
import 'package:audio_player_list_with_drift/screen/provider/add_audio_provider_screen.dart';
import 'package:audio_player_list_with_drift/screen/provider/audio_details_provider_screen.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:provider/provider.dart';

class AudioListWithProviderScreen extends StatefulWidget {
  const AudioListWithProviderScreen({super.key});

  @override
  State<AudioListWithProviderScreen> createState() => _AudioListWithProviderScreenState();
}

class _AudioListWithProviderScreenState extends State<AudioListWithProviderScreen> {

  AudioPlayerProviderController? _audioPlayerProviderController;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AudioListProviderController>(context, listen: false).getAudioListData(context);
    Provider.of<AudioPlayerProviderController>(context, listen: false).initAudioPlayer();
  }

  @override
  void dispose() {
    Provider.of<AudioListProviderController>(context, listen: false).dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String playedMinutesString = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String playedSecondsString = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$playedMinutesString:$playedSecondsString';
  }

  void navigateToAddAudioScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouter.addAudioWithProviderScreen,
    );
  }

  void navigateToAudioDetailsScreen(
    int audioId,
  ) async {
    Navigator.pushNamed(context, AppRouter.audioDetailsWithProviderScreen, arguments: AudioDetailWithProviderScreenArguments(audioId: audioId));
  }

  Future<void> _showDeleteAudioDialog(BuildContext context, int audioId) {
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
                setState(() {
                  Provider.of<AppDb>(context, listen: false).getAudioList();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAudio(int audioId) {
    Provider.of<AppDb>(context, listen: false).deleteAudio(audioId);

    Provider.of<AudioListProviderController>(context, listen: false).refreshAudioList(context);
  }

  Widget _renderPlayDuration(int total, AudioPlayerState audioPlayerState, BuildContext context) {

    if (audioPlayerState != AudioPlayerState.play) {
      return Row(
        children: [
          Selector<AudioPlayerProviderController, int>(
              selector: (context, controller) => controller.position,
              builder: (BuildContext context, position, Widget? child) {
              return Text(
                _formatDuration(Duration(seconds: position)),
                style: const TextStyle(fontSize: 14),
              );
            }
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

    _audioPlayerProviderController ??= context.watch<AudioPlayerProviderController>();
    // _audioPlayerProviderController ??= context.select<AudioPlayerProviderController, CurrentPlayingInfo>((value) => null)

    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio List with Provider"),
        actions: [
          IconButton(
              onPressed: () {
                navigateToAddAudioScreen(context);
              },
              icon: const Icon(Icons.add_circle_rounded))
        ],
      ),
      body: StreamBuilder<List<AudioEntityData>>(
          stream: Provider.of<AudioListProviderController>(context, listen: false).audioListStream,
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
                              navigateToAudioDetailsScreen(
                                snapshot.data![index].audioId,
                              );
                            },
                            onLongPress: () {
                              _showDeleteAudioDialog(context, snapshot.data![index].audioId);
                            },
                            title: Text(snapshot.data![index].audioName!),
                            subtitle: Selector<AudioPlayerProviderController, CurrentPlayingInfo>(
                                selector: (context, controller) => controller.currentPlayingInfo,
                                builder: (BuildContext context, info, Widget? child){
                                  var audioPlayerState = AudioPlayerState.play;

                                  if (info.audioId == snapshot.data![index].audioId) {
                                    // if(audioPlayerController.position.inSeconds == audioPlayerController.duration.inSeconds){
                                    //   audioPlayerState = AudioPlayerState.play;
                                    // }else {
                                    audioPlayerState = info.playerState == AudioPlayerState.play ? AudioPlayerState.pause : AudioPlayerState.play;
                                    // }
                                  }

                                  return _renderPlayDuration(snapshot.data![index].totalLength!, audioPlayerState, context);
                                }
                            ),
                            // subtitle: snapshot.data![index].playPosition! != 0 ? Text("${_formatDuration(Duration(seconds: snapshot.data![index].playPosition!))} - ${_formatDuration(Duration(seconds: snapshot.data![index].totalLength!))}") : Text("0 - ${_formatDuration(Duration(seconds: snapshot.data![index].totalLength!))}"),
                            trailing: Selector<AudioPlayerProviderController, CurrentPlayingInfo>(
                              selector: (context, controller) => controller.currentPlayingInfo,
                              builder: (BuildContext context, info, Widget? child) {
                                var iconData = Icons.play_arrow;
                                var audioPlayerState = AudioPlayerState.play;

                                if (info.audioId == snapshot.data![index].audioId) {
                                  if(info.playerState == AudioPlayerState.play){
                                    AudioPlayerState.pause;
                                  }
                                  iconData = info.playerState == AudioPlayerState.play ? Icons.pause : Icons.play_arrow;
                                  audioPlayerState = info.playerState == AudioPlayerState.play ? AudioPlayerState.pause : AudioPlayerState.play;
                                  Future.delayed(Duration.zero,(){
                                    _audioPlayerProviderController!.updateButtonSongsEnd(snapshot.data![index].audioId, snapshot.data![index].totalLength!);
                                  });
                                }
                                return Container(
                                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(50)),
                                    child: IconButton(
                                      icon: Icon(
                                        color: Colors.white,
                                        iconData,
                                      ),
                                      onPressed: () {
                                        // print("Bool: ${controller.isPlaying}");
                                        context.read<AudioPlayerProviderController>().playAudio(audioPlayerState, snapshot.data![index].audioURL!, snapshot.data![index].audioId!);
                                      },
                                    ));
                              },
                            )
                            // Container(
                            //   decoration: BoxDecoration(
                            //       color: Colors.blue,
                            //       borderRadius: BorderRadius.circular(50)),
                            //   child: snapshot.data![index].isPlaying == false
                            //       ? IconButton(
                            //           icon: const Icon(
                            //             color: Colors.white,
                            //             Icons.play_arrow,
                            //           ),
                            //           onPressed: () {
                            //             playAudio(
                            //                 snapshot.data![index].isPlaying!,
                            //                 snapshot.data![index].audioId,);
                            //           },
                            //         )
                            //       : IconButton(
                            //           icon: const Icon(
                            //               color: Colors.white, Icons.pause),
                            //           onPressed: () {
                            //             playAudio(
                            //                 snapshot.data![index].isPlaying!,
                            //                 snapshot.data![index].audioId,);
                            //           },
                            //         ),
                            // ),
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
