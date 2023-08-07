import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:provider/provider.dart';

class AudioListProviderController {

  List<AudioEntityData>? audioList;

  final StreamController<List<AudioEntityData>> _audioListController =
  StreamController<List<AudioEntityData>>();

  Stream<List<AudioEntityData>> get audioListStream =>
      _audioListController.stream;

  void dispose() {
    _audioListController.close();
  }

  Future<void> getAudioListData(BuildContext context) async {

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
    }catch (ex){
      Fimber.e('d;;exception', ex: ex);
    }
  }

  Future<void> refreshAudioList(BuildContext context) async {
    try {
      if (audioList != null) {
        audioList!.clear();
      }
      audioList = await Provider.of<AppDb>(context, listen: false).getAudioList();

      if (audioList != null) {
        _audioListController.sink.add(audioList!);
      }
      // notifyListeners();

    } catch (ex) {
      Fimber.e('d;;exception', ex: ex);
    }
  }
}