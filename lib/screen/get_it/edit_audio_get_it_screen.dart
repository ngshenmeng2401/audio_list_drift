import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_controller.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_fimber/flutter_fimber.dart';

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

  final AudioController audioController = AudioController();
  AudioEntityData? _audioEntityData;

  @override
  void initState() {
    getAudioData();

    super.initState();
  }

  Future<void> getAudioData() async {
    try{
      _audioEntityData = await getIt.get<AppDb>().getAudio(widget.arguments.audioId);
      if(_audioEntityData != null){
        // _audioController.sink.add(_audioEntityData!);
        audioController.musicNameController.text = _audioEntityData!.audioName!;
        audioController.musicURLController.text = _audioEntityData!.audioURL!;
        audioController.totalLengthController.text = _audioEntityData!.totalLength.toString();
      }
    }catch (ex){
      Fimber.e('d;;exception', ex: ex);
    }

  }

  @override
  void dispose() {
    audioController.musicNameController.dispose();
    audioController.musicURLController.dispose();
    audioController.totalLengthController.dispose();
    super.dispose();
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
                        audioController.checkTextField();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: audioController.musicNameController,
                    decoration: InputDecoration(
                        labelText: "Music Name",
                        suffixIcon: audioController.isMusicNameEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    audioController.clearTextField(ClearTextFieldType.musicName);
                                  });
                                },
                                icon: const Icon(Icons.clear_rounded))),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        audioController.checkTextField();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: audioController.musicURLController,
                    decoration: InputDecoration(
                        labelText: "Music URL",
                        suffixIcon: audioController.isMusicURLEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    audioController.clearTextField(ClearTextFieldType.musicURL);
                                  });
                                },
                                icon: const Icon(Icons.clear_rounded))),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        audioController.checkTextField();
                      })
                    },
                    keyboardType: TextInputType.number,
                    controller: audioController.totalLengthController,
                    decoration: InputDecoration(
                        labelText: "Total Length",
                        suffixIcon: audioController.isTotalLengthEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    audioController.clearTextField(ClearTextFieldType.totalLength);
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
                      onPressed: audioController.isEmptyEdit
                          ? null
                          : () {
                              audioController.editAudioToDb(context, widget.arguments.audioId);
                            },
                      child: const Text("Edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ))),
                  const SizedBox(height: 15),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: screenWidth,
                      height: screenHeight / 18,
                      color: Colors.blue,
                      onPressed: null,
                      child: const Text("Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ))),
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
