import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_list_controller.dart';
import 'package:audio_player_list_with_drift/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

class AddAudioWithGetItScreen extends StatefulWidget {
  final AddAudioWithGetItScreenArguments arguments;

  const AddAudioWithGetItScreen({
    Key? key,
    required Object? arguments,
  })  : assert(arguments != null && arguments is AddAudioWithGetItScreenArguments),
        this.arguments = arguments as AddAudioWithGetItScreenArguments,
        super(key: key);

  @override
  State<AddAudioWithGetItScreen> createState() => _AddAudioWithGetItScreenState();
}

class _AddAudioWithGetItScreenState extends State<AddAudioWithGetItScreen> {

  final TextEditingController musicNameController = TextEditingController();
  final TextEditingController musicURLController = TextEditingController();
  final TextEditingController totalLengthController = TextEditingController();
  var isEmptyAdd = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    musicNameController.dispose();
    musicURLController.dispose();
    totalLengthController.dispose();
    super.dispose();
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
                    onChanged: (value) => {
                      setState(() {
                        checkTextFieldIsEmpty();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: musicNameController,
                    decoration: const InputDecoration(
                      labelText: "Music Name",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        checkTextFieldIsEmpty();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: musicURLController,
                    decoration: const InputDecoration(
                      labelText: "Music URL",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        checkTextFieldIsEmpty();
                      })
                    },
                    keyboardType: TextInputType.number,
                    controller: totalLengthController,
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
                      onPressed: !isEmptyAdd
                          ? null
                          : () {
                        addAudioToDb(context);
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
      ),
    );
  }
}

class AddAudioWithGetItScreenArguments {
  final Function() backButtonCallback;

  AddAudioWithGetItScreenArguments({required this.backButtonCallback});
}
