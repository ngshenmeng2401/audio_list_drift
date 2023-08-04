import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:drift/drift.dart' as drift;
import 'package:just_audio/just_audio.dart';

class AudioListController {
  final audioListVN = ValueNotifier<List<AudioEntityData>>([]);

  Future<void> refreshAudioList() async {
    try {
      // print("Audio List before clear: $audioList");

      // if (audioListVN.value != null) {
        audioListVN.value.clear();
      // }
      audioListVN.value = await getIt.get<AppDb>().getAudioList();

      // if (audioListVN.value != null) {
      //   audioListControllerStream.sink.add(audioList!);
      // }
      // print("Audio List after get data: $audioList");
    } catch (ex) {
      Fimber.e('d;;exception', ex: ex);
    }
  }

  void dispose() {
    audioListVN.dispose();
  }
}

enum ClearTextFieldType { musicName, musicURL, totalLength }

class AudioDriftController {
  List<AudioEntityData>? audioList;

  final TextEditingController musicNameController = TextEditingController();
  final TextEditingController musicURLController = TextEditingController();
  final TextEditingController totalLengthController = TextEditingController();
  var isEmptyAdd = false,
      isEmptyEdit = false,
      isMusicNameEmpty = false,
      isMusicURLEmpty = false,
      isTotalLengthEmpty = false;

  final StreamController<List<AudioEntityData>> audioListControllerStream =
      StreamController<List<AudioEntityData>>();

  Stream<List<AudioEntityData>> get audioListStream =>
      audioListControllerStream.stream;

  Future<void> getAudioListData() async {
    try {
      print("Audio List before clear: $audioList");

      if (audioList != null) {
        audioList!.clear();
      }
      audioList = await getIt.get<AppDb>().getAudioList();

      if (audioList != null) {
        audioListControllerStream.sink.add(audioList!);
      }
      print("Audio List after get data: $audioList");
    } catch (ex) {
      Fimber.e('d;;exception', ex: ex);
    }
  }

  void checkTextFieldIsEmpty() {
    if (musicNameController.text.isEmpty ||
        musicURLController.text.isEmpty ||
        totalLengthController.text.isEmpty) {
      isEmptyAdd = false;
    } else {
      isEmptyAdd = true;
    }
  }

  void addAudioToDb(BuildContext context) {
    final entity = AudioEntityCompanion(
      audioName: drift.Value(musicNameController.text),
      audioURL: drift.Value(musicURLController.text),
      totalLength: drift.Value(int.parse(totalLengthController.text)),
      playPosition: const drift.Value(0),
      isPlaying: const drift.Value(false),
    );

    getIt.get<AppDb>().insertAudio(entity).then((value) => showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Add Successful'),
              content: const Text(
                '',
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ));
    musicNameController.clear();
    musicURLController.clear();
    totalLengthController.clear();
  }

  void checkTextField() {
    if (musicNameController.text.isEmpty &&
        musicURLController.text.isNotEmpty &&
        totalLengthController.text.isNotEmpty) {
        isMusicNameEmpty = true;
        isMusicURLEmpty = false;
        isTotalLengthEmpty = false;
        isEmptyEdit = true;
    } else if (musicNameController.text.isNotEmpty &&
        musicURLController.text.isNotEmpty &&
        totalLengthController.text.isEmpty) {
        isMusicNameEmpty = false;
        isMusicURLEmpty = false;
        isTotalLengthEmpty = true;
        isEmptyEdit = true;
    } else if (musicNameController.text.isNotEmpty &&
        musicURLController.text.isEmpty &&
        totalLengthController.text.isNotEmpty) {
        isMusicNameEmpty = false;
        isMusicURLEmpty = true;
        isTotalLengthEmpty = false;
        isEmptyEdit = true;
    } else if (musicNameController.text.isEmpty ||
        musicURLController.text.isEmpty ||
        totalLengthController.text.isEmpty) {
        isMusicNameEmpty = true;
        isMusicURLEmpty = true;
        isTotalLengthEmpty = true;
        isEmptyEdit = true;
    } else {
        isMusicNameEmpty = false;
        isMusicURLEmpty = false;
        isTotalLengthEmpty = false;
        isEmptyEdit = false;
    }
  }

  void clearTextField(ClearTextFieldType clearTextFieldType) {
    switch (clearTextFieldType) {
      case ClearTextFieldType.musicName:
        musicNameController.clear();
          isEmptyEdit = true;
          isMusicNameEmpty = true;
        break;
      case ClearTextFieldType.musicURL:
        musicURLController.clear();
          isEmptyEdit = true;
          isMusicURLEmpty = true;
        break;
      case ClearTextFieldType.totalLength:
        totalLengthController.clear();
          isEmptyEdit = true;
          isTotalLengthEmpty = true;
        break;
    }
  }

  void editAudioToDb(BuildContext context, int audioId) {
    final entity = AudioEntityCompanion(
      audioId: drift.Value(audioId),
      audioName: drift.Value(musicNameController.text),
      audioURL: drift.Value(musicURLController.text),
      totalLength: drift.Value(int.parse(totalLengthController.text)),
      playPosition: const drift.Value(0),
    );

    getIt.get<AppDb>().updateAudio(entity).then((value) => showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Successful'),
          content: const Text(
            '',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ));
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

    getAudioListData();
  }
}
