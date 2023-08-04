import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_drift_controller.dart';
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
  State<AudioListWithGetItScreen> createState() =>
      _AudioListWithGetItScreenState();
}

class _AudioListWithGetItScreenState extends State<AudioListWithGetItScreen> {


  final GetIt getIt = GetIt.instance;
  late AudioDriftController audioDriftController;
  late AudioPlayerController audioPlayerController;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioDriftController = getIt.get<AudioDriftController>();
    audioPlayerController = getIt.get<AudioPlayerController>();

    audioDriftController.getAudioListData();
    // audioPlayerController.initPlayButtonList();

    // setState(() {});
    // audioPlayerController.audioPlayer.positionStream.listen((event) {
    //   audioPlayerController.position = event;
    //   setState(() {
    //     print("position: ${audioPlayerController.position}");
    //   });
    // });
  }

  @override
  void dispose() {
    audioDriftController.audioListControllerStream.close();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String playedMinutesString =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String playedSecondsString =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$playedMinutesString:$playedSecondsString';
  }

  void navigateToAddAudioScreen(BuildContext context) {
    // Navigator.pushNamed(context, AppRouter.addAudioWithGetItScreen,
    //     arguments: AddAudioWithGetItScreenArguments(
    //         backButtonCallback: audioDriftController.getAudioListData,
    //         backButtonCallback2: audioPlayerController.initPlayButtonList));
  }

  void navigateToAudioDetailsScreen(
      int audioId, int index, String audioURL) async {
    Navigator.pushNamed(context, AppRouter.audioDetailsWithGetItScreen,
        arguments: AudioDetailWithGetItScreenArguments(
            audioId: audioId,
            index: index,
            audioURL: audioURL,
            backButtonCallback: audioDriftController.getAudioListData,
            backButtonCallback2: audioDriftController.getAudioListData
        ));
  }

  Widget _renderPlayDuration(int total, bool isPlayed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: !isPlayed
          ? Row(
              children: [
                // audioPlayerController.position.inSeconds.toDouble() ==
                //         audioPlayerController.duration.inSeconds.toDouble()
                //     ? Text(
                //         _formatDuration(const Duration(seconds: 0)),
                //         style: const TextStyle(fontSize: 14),
                //       )
                //     :
                // Text(
                //         _formatDuration(Duration(
                //             seconds: audioPlayerController.position.inSeconds
                //                 .toInt())),
                //         style: const TextStyle(fontSize: 14),
                //       ),
                const SizedBox(width: 5,),
                const Text(
                  "-",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 5,),
                Text(
                  _formatDuration(Duration(seconds: total)),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            )
          : Text(
              // "0",
              _formatDuration(Duration(seconds: total)),
              style: const TextStyle(fontSize: 14),
            ),
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
      body:
      StreamBuilder<List<AudioEntityData>>(
          stream: audioDriftController.audioListStream,
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
                                index,
                                snapshot.data![index].audioURL!);
                          },
                          onLongPress: () {
                            audioDriftController.showDeleteAudioDialog(
                                context, snapshot.data![index].audioId);
                          },
                          title: Text(snapshot.data![index].audioName!),
                          // subtitle: _renderPlayDuration(
                          //     snapshot.data![index].totalLength!,
                          //     !audioPlayerController.isPlayedList[index]),
                          trailing: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50)),
                            child:
                            // !audioPlayerController.isPlayedList[index] ?
                            StreamBuilder<int>(
                              stream: audioPlayerController.audioIdStream,
                              builder: (context, audioPlayerControllerSnapshot) {
                                print("d;; ${audioPlayerControllerSnapshot.data}");
                                if(audioPlayerControllerSnapshot.data == snapshot.data![index].audioId){
                                  return IconButton(
                                    icon: const Icon(
                                      color: Colors.white,
                                      Icons.pause,
                                    ),
                                    onPressed: () {
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
                                }else{
                                  return IconButton(
                                    icon: const Icon(
                                      color: Colors.white,
                                      Icons.play_arrow,
                                    ),
                                    onPressed: () {
                                      audioPlayerController.audioIdControllerStream.sink.add(snapshot.data![index].audioId);
                                      // setState(() {
                                      //   audioPlayerController.playAudioList(
                                      //     audioPlayerController
                                      //         .isPlayedList[index],
                                      //     index,
                                      //   );
                                      // });
                                    },
                                  );
                                }

                              }
                            )
                                // : IconButton(
                                //     icon: const Icon(
                                //         color: Colors.white, Icons.pause),
                                //     onPressed: () {
                                //       setState(() {
                                //         audioPlayerController.playAudioList(
                                //           audioPlayerController
                                //               .isPlayedList[index],
                                //           index,
                                //         );
                                //       });
                                //     },
                                //   ),
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
