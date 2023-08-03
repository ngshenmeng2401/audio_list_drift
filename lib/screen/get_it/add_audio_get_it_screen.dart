import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/screen/controller/audio_controller.dart';
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

  final AudioController audioController = AudioController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                        audioController.checkTextFieldIsEmpty();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: audioController.musicNameController,
                    decoration: const InputDecoration(
                      labelText: "Music Name",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        audioController.checkTextFieldIsEmpty();
                      })
                    },
                    keyboardType: TextInputType.name,
                    controller: audioController.musicURLController,
                    decoration: const InputDecoration(
                      labelText: "Music URL",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enableInteractiveSelection: true,
                    onChanged: (value) => {
                      setState(() {
                        audioController.checkTextFieldIsEmpty();
                      })
                    },
                    keyboardType: TextInputType.number,
                    controller: audioController.totalLengthController,
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
                      onPressed: !audioController.isEmptyAdd
                          ? null
                          : () {
                        audioController.addAudioToDb(context);
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
