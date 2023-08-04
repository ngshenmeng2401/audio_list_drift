import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:drift/drift.dart' as drift;

class AudioListController {
  final audioListVN = ValueNotifier<List<AudioEntityData>>([]);

  List<AudioEntityData>? audioList;

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

  Future<void> refreshAudioList() async {
    try {
      if (audioList != null) {
        audioList!.clear();
      }
      audioList = await getIt.get<AppDb>().getAudioList();

      if (audioList != null) {
        audioListControllerStream.sink.add(audioList!);
      }

      // audioListVN.value.clear();
      //
      // audioListVN.value = await getIt.get<AppDb>().getAudioList();

    } catch (ex) {
      Fimber.e('d;;exception', ex: ex);
    }
  }

  void dispose() {
    audioListVN.dispose();
  }
}

