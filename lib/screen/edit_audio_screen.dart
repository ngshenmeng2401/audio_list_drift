import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

enum ClearTextFieldType { musicName, musicURL, totalLength }

class EditAudioScreen extends StatefulWidget {
  final int audioId;

  const EditAudioScreen({super.key, required this.audioId});

  @override
  State<EditAudioScreen> createState() => _EditAudioScreenState();
}

class _EditAudioScreenState extends State<EditAudioScreen> {
  final TextEditingController _musicNameController = TextEditingController();
  final TextEditingController _musicURLController = TextEditingController();
  final TextEditingController _totalLengthController = TextEditingController();
  var isEmpty = false,
      isMusicNameEmpty = false,
      isMusicURLEmpty = false,
      isTotalLengthEmpty = false;
  late AppDb _db;
  AudioEntityData? _audioEntityData;

  @override
  void initState() {
    _db = AppDb();
    getAudioData();

    super.initState();
  }

  Future<void> getAudioData() async {
    _audioEntityData = await _db.getAudio(widget.audioId);
    _musicNameController.text = _audioEntityData!.audioName;
    _musicURLController.text = _audioEntityData!.audioURL;
    _totalLengthController.text = _audioEntityData!.totalLength.toString();
  }

  @override
  void dispose() {
    _db.close();
    _musicNameController.dispose();
    _musicURLController.dispose();
    _totalLengthController.dispose();
    super.dispose();
  }

  void checkTextField() {
    if (_musicNameController.text.isEmpty &&
        _musicURLController.text.isNotEmpty &&
        _totalLengthController.text.isNotEmpty) {
      setState(() {
        isMusicNameEmpty = true;
        isMusicURLEmpty = false;
        isTotalLengthEmpty = false;
        isEmpty = true;
      });
    } else if (_musicNameController.text.isNotEmpty &&
        _musicURLController.text.isNotEmpty &&
        _totalLengthController.text.isEmpty) {
      setState(() {
        isMusicNameEmpty = false;
        isMusicURLEmpty = false;
        isTotalLengthEmpty = true;
        isEmpty = true;
      });
    } else if (_musicNameController.text.isNotEmpty &&
        _musicURLController.text.isEmpty &&
        _totalLengthController.text.isNotEmpty) {
      setState(() {
        isMusicNameEmpty = false;
        isMusicURLEmpty = true;
        isTotalLengthEmpty = false;
        isEmpty = true;
      });
    } else if (_musicNameController.text.isEmpty ||
        _musicURLController.text.isEmpty ||
        _totalLengthController.text.isEmpty) {
      setState(() {
        isMusicNameEmpty = true;
        isMusicURLEmpty = true;
        isTotalLengthEmpty = true;
        isEmpty = true;
      });
    } else {
      setState(() {
        isMusicNameEmpty = false;
        isMusicURLEmpty = false;
        isTotalLengthEmpty = false;
        isEmpty = false;
      });
    }
  }

  void clearTextField(ClearTextFieldType clearTextFieldType) {
    switch (clearTextFieldType) {
      case ClearTextFieldType.musicName:
        _musicNameController.clear();
        setState(() {
          isEmpty = true;
          isMusicNameEmpty = true;
        });
        break;
      case ClearTextFieldType.musicURL:
        _musicURLController.clear();
        setState(() {
          isEmpty = true;
          isMusicURLEmpty = true;
        });
        break;
      case ClearTextFieldType.totalLength:
        _totalLengthController.clear();
        setState(() {
          isEmpty = true;
          isTotalLengthEmpty = true;
        });
        break;
    }
  }

  void editAudioToDb() {
    final entity = AudioEntityCompanion(
      audioId: drift.Value(widget.audioId),
      audioName: drift.Value(_musicNameController.text),
      audioURL: drift.Value(_musicURLController.text),
      totalLength: drift.Value(int.parse(_totalLengthController.text)),
      playPosition: const drift.Value(0),
    );

    _db.updateAudio(entity).then((value) => ScaffoldMessenger.of(context)
            .showMaterialBanner(
                MaterialBanner(content: Text('Update audio: $value'), actions: [
          TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text('Close'))
        ])));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                  onChanged: (value) => checkTextField(),
                  keyboardType: TextInputType.name,
                  controller: _musicNameController,
                  decoration: InputDecoration(
                      labelText: "Music Name",
                      suffixIcon: isMusicNameEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                clearTextField(ClearTextFieldType.musicName);
                              },
                              icon: const Icon(Icons.clear_rounded))),
                ),
                const SizedBox(height: 15),
                TextField(
                  enableInteractiveSelection: true,
                  onChanged: (value) => checkTextField(),
                  keyboardType: TextInputType.name,
                  controller: _musicURLController,
                  decoration: InputDecoration(
                      labelText: "Music URL",
                      suffixIcon: isMusicURLEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                clearTextField(ClearTextFieldType.musicURL);
                              },
                              icon: const Icon(Icons.clear_rounded))),
                ),
                const SizedBox(height: 15),
                TextField(
                  enableInteractiveSelection: true,
                  onChanged: (value) => checkTextField(),
                  keyboardType: TextInputType.number,
                  controller: _totalLengthController,
                  decoration: InputDecoration(
                      labelText: "Total Length",
                      suffixIcon: isTotalLengthEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                clearTextField(ClearTextFieldType.totalLength);
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
                    onPressed: isEmpty
                        ? null
                        : () {
                            editAudioToDb();
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
    );
  }
}
