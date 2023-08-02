import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/add_audio_screen.dart';
import 'package:audio_player_list_with_drift/screen/audio_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

class AudioListWithProviderScreen extends StatefulWidget {
  const AudioListWithProviderScreen({super.key});

  @override
  State<AudioListWithProviderScreen> createState() => _AudioListWithProviderScreenState();
}

class _AudioListWithProviderScreenState extends State<AudioListWithProviderScreen> {
  List<bool> isPlayedList = [];
  List<AudioEntityData>? audioList;
  Duration duration = const Duration();
  Duration position = const Duration();
  final StreamController<List<AudioEntityData>> _audioListController =
      StreamController<List<AudioEntityData>>();

  Stream<List<AudioEntityData>> get _audioListStream =>
      _audioListController.stream;

  @override
  void initState() {
    super.initState();
    getAudioListData();
  }

  @override
  void dispose() {
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
    Navigator.pushNamed(context, AppRouter.addAudioScreen,
            arguments:
                AddAudioScreenArguments(backButtonCallback: getAudioListData))
    ;
  }

  void navigateToAudioDetailsScreen(
    int audioId,
  ) async {

    Navigator.pushNamed(context, AppRouter.audioDetailsScreen,
            arguments: AudioDetailScreenArguments(
                audioId: audioId, backButtonCallback: getAudioListData))
    ;
  }

  Future<void> getAudioListData() async {

    try{
      print("Audio List before clear: $audioList");

      if (audioList != null) {
        audioList!.clear();
      }
      audioList = await Provider.of<AppDb>(context, listen: false).getAudioList();

      if (audioList != null) {
        _audioListController.sink.add(audioList!);
      }

      print("Audio List after get data: $audioList");
    }catch (e){
      print(e);
    }

  }

  void playAudio(
      bool isPlayed, int audioId) {
    var entity;

    setState(() {
      if (isPlayed == true) {
        entity = AudioEntityCompanion(
          audioId: drift.Value(audioId),
          playPosition: const drift.Value(0),
          isPlaying: const drift.Value(false),
        );
      } else {
        entity = AudioEntityCompanion(
          audioId: drift.Value(audioId),
          playPosition: const drift.Value(0),
          isPlaying: const drift.Value(false),
        );
      }
      Provider.of<AppDb>(context, listen: false).updateAudio(entity);
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
          stream: Provider.of<AppDb>(context).getAudioList().asStream(),
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
                                snapshot.data![index].audioId,);
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
                                      playAudio(
                                          snapshot.data![index].isPlaying!,
                                          snapshot.data![index].audioId,);
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(
                                        color: Colors.white, Icons.pause),
                                    onPressed: () {
                                      playAudio(
                                          snapshot.data![index].isPlaying!,
                                          snapshot.data![index].audioId,);
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
