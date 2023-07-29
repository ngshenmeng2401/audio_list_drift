import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

class AddAudioScreen extends StatefulWidget {
  const AddAudioScreen({super.key});

  @override
  State<AddAudioScreen> createState() => _AddAudioScreenState();
}

class _AddAudioScreenState extends State<AddAudioScreen> {
  final TextEditingController _musicNameController = TextEditingController();
  final TextEditingController _musicURLController = TextEditingController();
  final TextEditingController _totalLengthController = TextEditingController();
  var isEmpty = false;
  late AppDb _db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _db = AppDb();
  }

  @override
  void dispose() {
    _db.close();
    _musicNameController.dispose();
    _musicURLController.dispose();
    _totalLengthController.dispose();
    super.dispose();
  }

  void checkTextFieldIsEmpty() {
    if (_musicNameController.text.isEmpty ||
        _musicURLController.text.isEmpty ||
        _totalLengthController.text.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
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
        title: Text("Add Audio"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: [
                TextField(
                  enableInteractiveSelection: true,
                  onChanged: (value) => checkTextFieldIsEmpty(),
                  keyboardType: TextInputType.name,
                  controller: _musicNameController,
                  decoration: const InputDecoration(
                    labelText: "Music Name",
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  enableInteractiveSelection: true,
                  onChanged: (value) => checkTextFieldIsEmpty(),
                  keyboardType: TextInputType.name,
                  controller: _musicURLController,
                  decoration: const InputDecoration(
                    labelText: "Music URL",
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  enableInteractiveSelection: true,
                  onChanged: (value) => checkTextFieldIsEmpty(),
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
                    onPressed: isEmpty
                        ? null
                        : () {
                            addAudioToDb();
                          },
                    child: const Text("Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
