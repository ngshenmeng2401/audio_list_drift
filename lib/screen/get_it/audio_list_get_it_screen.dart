import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_drift_controller.dart';
import 'package:audio_player_list_with_drift/screen/get_it/add_audio_get_it_screen.dart';
import 'package:audio_player_list_with_drift/screen/get_it/audio_details_get_it_screen.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_fimber/flutter_fimber.dart';

class AudioListWithGetItScreen extends StatefulWidget {
  const AudioListWithGetItScreen({super.key});

  @override
  State<AudioListWithGetItScreen> createState() =>
      _AudioListWithGetItScreenState();
}

class _AudioListWithGetItScreenState extends State<AudioListWithGetItScreen> {
  final AudioDriftController audioDriftController = AudioDriftController();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioDriftController.getAudioListData();
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
    Navigator.pushNamed(context, AppRouter.addAudioWithGetItScreen,
        arguments: AddAudioWithGetItScreenArguments(
            backButtonCallback: audioDriftController.getAudioListData));
  }

  void navigateToAudioDetailsScreen(
    int audioId,
    int index,
  ) async {
    Navigator.pushNamed(context, AppRouter.audioDetailsWithGetItScreen,
        arguments: AudioDetailWithGetItScreenArguments(
            audioId: audioId,
            index: index,
            backButtonCallback: audioDriftController.getAudioListData));
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
                                snapshot.data![index].audioId, index);
                          },
                          onLongPress: () {
                            audioDriftController.showDeleteAudioDialog(
                                context, snapshot.data![index].audioId);
                          },
                          title: Text(snapshot.data![index].audioName!),
                          subtitle: snapshot.data![index].playPosition! != 0
                              ? Text(
                                  "${_formatDuration(Duration(seconds: snapshot.data![index].playPosition!))} - ${_formatDuration(Duration(seconds: snapshot.data![index].totalLength!))}")
                              : Text(
                                  "0 - ${_formatDuration(Duration(seconds: snapshot.data![index].totalLength!))}"),
                          trailing: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50)),
                            child: !audioDriftController.isPlayedList[index]
                                ? IconButton(
                                    icon: const Icon(
                                      color: Colors.white,
                                      Icons.play_arrow,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        audioDriftController.playAudio(
                                            audioDriftController.isPlayedList[index],
                                            snapshot.data![index].audioId,
                                            index,
                                            snapshot.data![index].audioURL!);
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(
                                        color: Colors.white, Icons.pause),
                                    onPressed: () {
                                      setState(() {
                                        audioDriftController.playAudio(
                                            audioDriftController.isPlayedList[index],
                                            snapshot.data![index].audioId,
                                            index,
                                            snapshot.data![index].audioURL!);
                                      });
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
