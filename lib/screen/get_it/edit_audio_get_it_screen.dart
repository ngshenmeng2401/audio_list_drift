import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_list_controller.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_player_controller.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:get_it/get_it.dart';

enum ClearTextFieldType { musicName, musicURL, totalLength }

class EditAudioWithGetItScreen extends StatefulWidget {
  final EditAudioWithGetItScreenArguments arguments;

  const EditAudioWithGetItScreen({
    Key? key,
    required Object? arguments,
  })  : assert(arguments != null && arguments is EditAudioWithGetItScreenArguments),
        this.arguments = arguments as EditAudioWithGetItScreenArguments,
        super(key: key);

  @override
  State<EditAudioWithGetItScreen> createState() => _EditAudioWithGetItScreenState();
}

class _EditAudioWithGetItScreenState extends State<EditAudioWithGetItScreen> {

  // final AudioDriftController audioDriftController = AudioDriftController();
  // final AudioPlayerController audioPlayerController = AudioPlayerController();
  final TextEditingController musicNameController = TextEditingController();
  final TextEditingController musicURLController = TextEditingController();
  final TextEditingController totalLengthController = TextEditingController();
  var isEmptyEdit = false,
      isMusicNameEmpty = false,
      isMusicURLEmpty = false,
      isTotalLengthEmpty = false;
  AudioEntityData? _audioEntityData;

  @override
  void initState() {
    super.initState();
    getAudioData();
  }

  Future<void> getAudioData() async {
    try{
      _audioEntityData = await getIt.get<AppDb>().getAudio(widget.arguments.audioId);
      if(_audioEntityData != null){
        // _audioController.sink.add(_audioEntityData!);
        musicNameController.text = _audioEntityData!.audioName!;
        musicURLController.text = _audioEntityData!.audioURL!;
        totalLengthController.text = _audioEntityData!.totalLength.toString();
      }
    }catch (ex){
      Fimber.e('d;;exception', ex: ex);
    }

  }

  @override
  void dispose() {
    musicNameController.dispose();
    musicURLController.dispose();
    totalLengthController.dispose();

    super.dispose();
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

  Future<bool> _onWillPop() async {
    widget.arguments.backButtonCallback();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Audio"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                children: [
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        checkTextField();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: musicNameController,
                    decoration: InputDecoration(
                        labelText: "Music Name",
                        suffixIcon: isMusicNameEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    clearTextField(ClearTextFieldType.musicName);
                                  });
                                },
                                icon: const Icon(Icons.clear_rounded))),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        checkTextField();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: musicURLController,
                    decoration: InputDecoration(
                        labelText: "Music URL",
                        suffixIcon: isMusicURLEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    clearTextField(ClearTextFieldType.musicURL);
                                  });
                                },
                                icon: const Icon(Icons.clear_rounded))),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        checkTextField();
                      })
                    },
                    keyboardType: TextInputType.number,
                    controller: totalLengthController,
                    decoration: InputDecoration(
                        labelText: "Total Length",
                        suffixIcon: isTotalLengthEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    clearTextField(ClearTextFieldType.totalLength);
                                  });
                                },
                                icon: const Icon(Icons.clear_rounded))),
                  ),
                  const SizedBox(height: 15),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: screenWidth,
                      height: screenHeight / 18,
                      color: Colors.blue,
                      onPressed: isEmptyEdit
                          ? null
                          : () async {
                              editAudioToDb(context, widget.arguments.audioId);
                              await GetIt.instance.get<AudioListController>().refreshAudioList();
                            },
                      child: const Text("Edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ))),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditAudioWithGetItScreenArguments {
  int audioId;
  final Function() backButtonCallback;

  EditAudioWithGetItScreenArguments(
      {required this.audioId, required this.backButtonCallback});
}
