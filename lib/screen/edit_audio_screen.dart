import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

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
  var isTyped = false;
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
    if (_musicNameController.text.isEmpty ||
        _musicURLController.text.isEmpty ||
        _totalLengthController.text.isEmpty) {
      setState(() {
        isTyped = false;
      });
    } else {
      setState(() {
        isTyped = true;
      });
    }
  }

  void addAudioToDb() {
    final entity = AudioEntityCompanion(
      audioName: drift.Value(_musicNameController.text),
      audioURL: drift.Value(_musicURLController.text),
      totalLength: drift.Value(int.parse(_totalLengthController.text)),
      playPosition: const drift.Value(0),
    );

    _db.insertAudio(entity).then((value) => ScaffoldMessenger.of(context)
            .showMaterialBanner(MaterialBanner(
                content: Text('New audio inserted $value'),
                actions: [
              TextButton(
                  onPressed: () =>
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                  child: const Text('Close'))
            ])));
    _musicNameController.clear();
    _musicURLController.clear();
    _totalLengthController.clear();
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
                  decoration: const InputDecoration(
                    labelText: "Music Name",
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  enableInteractiveSelection: true,
                  onChanged: (value) => checkTextField(),
                  keyboardType: TextInputType.name,
                  controller: _musicURLController,
                  decoration: const InputDecoration(
                    labelText: "Music URL",
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  enableInteractiveSelection: true,
                  onChanged: (value) => checkTextField(),
                  keyboardType: TextInputType.number,
                  controller: _totalLengthController,
                  decoration: const InputDecoration(
                    labelText: "Total Length",
                  ),
                ),
                const SizedBox(height: 15),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minWidth: screenWidth,
                    height: screenHeight / 18,
                    color: Colors.blue,
                    onPressed: isTyped
                        ? () {
                            addAudioToDb();
                          }
                        : null,
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
