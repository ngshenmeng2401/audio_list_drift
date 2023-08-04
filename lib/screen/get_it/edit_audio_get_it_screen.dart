import 'dart:async';

import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_drift_controller.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_player_controller.dart';
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

  final AudioDriftController audioDriftController = AudioDriftController();
  final AudioPlayerController audioPlayerController = AudioPlayerController();
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
        audioDriftController.musicNameController.text = _audioEntityData!.audioName!;
        audioDriftController.musicURLController.text = _audioEntityData!.audioURL!;
        audioDriftController.totalLengthController.text = _audioEntityData!.totalLength.toString();
      }
    }catch (ex){
      Fimber.e('d;;exception', ex: ex);
    }

  }

  @override
  void dispose() {
    audioDriftController.musicNameController.dispose();
    audioDriftController.musicURLController.dispose();
    audioDriftController.totalLengthController.dispose();
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
                        audioDriftController.checkTextField();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: audioDriftController.musicNameController,
                    decoration: InputDecoration(
                        labelText: "Music Name",
                        suffixIcon: audioDriftController.isMusicNameEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    audioDriftController.clearTextField(ClearTextFieldType.musicName);
                                  });
                                },
                                icon: const Icon(Icons.clear_rounded))),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        audioDriftController.checkTextField();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: audioDriftController.musicURLController,
                    decoration: InputDecoration(
                        labelText: "Music URL",
                        suffixIcon: audioDriftController.isMusicURLEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    audioDriftController.clearTextField(ClearTextFieldType.musicURL);
                                  });
                                },
                                icon: const Icon(Icons.clear_rounded))),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        audioDriftController.checkTextField();
                      })
                    },
                    keyboardType: TextInputType.number,
                    controller: audioDriftController.totalLengthController,
                    decoration: InputDecoration(
                        labelText: "Total Length",
                        suffixIcon: audioDriftController.isTotalLengthEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    audioDriftController.clearTextField(ClearTextFieldType.totalLength);
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
                      onPressed: audioDriftController.isEmptyEdit
                          ? null
                          : () {
                              audioDriftController.editAudioToDb(context, widget.arguments.audioId);
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
