import 'package:audio_player_list_with_drift/db/app_db.dart';
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
  final TextEditingController _musicNameController = TextEditingController();
  final TextEditingController _musicURLController = TextEditingController();
  final TextEditingController _totalLengthController = TextEditingController();
  var isEmpty = true;
  var addIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    _musicNameController.dispose();
    _musicURLController.dispose();
    _totalLengthController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    widget.arguments.backButtonCallback();
    return true;
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
    _musicNameController.clear();
    _musicURLController.clear();
    _totalLengthController.clear();
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
                              // addIndex++;
                              // Navigator.pop(context, addIndex.toString());
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
