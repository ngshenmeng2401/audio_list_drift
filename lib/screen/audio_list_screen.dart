import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/add_audio_screen.dart';
import 'package:audio_player_list_with_drift/screen/audio_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

class AudioListScreen extends StatefulWidget {
  const AudioListScreen({super.key});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  late AppDb _db;
  List<bool> isPlayedList = [];
  List<AudioEntityData>? audioList;
  Duration duration = const Duration();
  Duration position = const Duration();
  StreamController<List<AudioEntityData>> _audioListController =
      StreamController<List<AudioEntityData>>();

  Stream<List<AudioEntityData>> get _audioListStream =>
      _audioListController.stream;

  @override
  void initState() {
    super.initState();

    _db = AppDb();
    getAudioListData();
  }

  @override
  void dispose() {
    _db.close();
    _audioListController.close();
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
    Navigator.pushNamed(context, AppRouter.addAudioScreen, arguments: AddAudioScreenArguments(backButtonCallback: getAudioListData)).then((value) => () {
          setState(() {
            getAudioListData();
          });
        });
    // var result = await Navigator.push(
    //   context,
    //   // Create the SelectionScreen in the next step.
    //   MaterialPageRoute(
    //       builder: (context) => const AddAudioScreen()),
    // );
    // if (!mounted) return;
    // setState(() {
    //   isPlayedList.insert(int.parse(result), false);
    // });
    // print("isPlayedList: $isPlayedList");
  }

  void navigateToAudioDetailsScreen(
      int audioId,
      String audioName,
      String audioURL,
      int totalLength,
      int playPosition,
      bool isPlaying) async {
    Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => AudioDetailsScreen(
                audioId: audioId,
                audioURL: audioURL,
                audioName: audioName,
                totalLength: totalLength,
                playPosition: playPosition,
                isPlaying: isPlaying,
              )),
    ).then((value) => () {
          setState(() {
            _db.getAudioList();
          });
        });

    // Navigator.pushNamed(context, AppRouter.audioDetailsScreen,
    //         arguments: AudioDetailScreenArguments(audioId: audioId.toString()))
    //     .then((value) => () {
    //           setState(() {
    //             getAudioListData();
    //           });
    //         });
  }

  Future<void> getAudioListData() async {
    print("Audio List before clear: $audioList");

    if (audioList != null) {
      audioList!.clear();
    }
    audioList = await _db.getAudioList();

    if (audioList != null) {
      _audioListController.sink.add(audioList!);
    }

    print("Audio List after get data: $audioList");
  }

  void playAudio(
      bool isPlayed, int audioId, String audioURL, String audioName) {
    var entity;

    setState(() {
      if (isPlayed == true) {
        entity = AudioEntityCompanion(
          audioId: drift.Value(audioId),
          audioName: drift.Value(audioName),
          audioURL: drift.Value(audioURL),
          playPosition: const drift.Value(0),
          isPlaying: const drift.Value(false),
        );
      } else {
        entity = AudioEntityCompanion(
          audioId: drift.Value(audioId),
          audioName: drift.Value(audioName),
          audioURL: drift.Value(audioURL),
          playPosition: const drift.Value(0),
          isPlaying: const drift.Value(true),
        );
      }
      _db.updateAudio(entity);
    });
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
                  _db.getAudioList();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAudio(int audioId) {
    _db.deleteAudio(audioId);
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
      body: StreamBuilder(
          stream: _audioListStream,
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
                                snapshot.data![index].audioName!,
                                snapshot.data![index].audioURL!,
                                snapshot.data![index].totalLength!,
                                snapshot.data![index].playPosition!,
                                snapshot.data![index].isPlaying!);
                          },
                          onLongPress: () {
                            _showDeleteAudioDialog(
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
                            child: snapshot.data![index].isPlaying == false
                                ? IconButton(
                                    icon: const Icon(
                                      color: Colors.white,
                                      Icons.play_arrow,
                                    ),
                                    onPressed: () {
                                      // playAudio(
                                      //     snapshot.data![index].isPlaying!,
                                      //     snapshot.data![index].audioId,
                                      //     snapshot.data![index].audioURL!,
                                      //     snapshot.data![index].audioName!);
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(
                                        color: Colors.white, Icons.pause),
                                    onPressed: () {
                                      // playAudio(
                                      //     snapshot.data![index].isPlaying!,
                                      //     snapshot.data![index].audioId,
                                      //     snapshot.data![index].audioURL!,
                                      //     snapshot.data![index].audioName!);
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
