import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/audio_list_screen.dart';
import 'package:flutter/material.dart';

class AudioDetailsScreen extends StatefulWidget {
  final int audioId;
  const AudioDetailsScreen({super.key, required this.audioId});

  @override
  State<AudioDetailsScreen> createState() => _AudioDetailsScreenState();
}

class _AudioDetailsScreenState extends State<AudioDetailsScreen> {
  late AppDb _db;
  AudioEntityData? _audioEntityData;
  bool isPlayed = false;

  @override
  void initState() {
    _db = AppDb();
    getAudioData();

    // TODO: implement initState
    super.initState();
  }

  Future<void> getAudioData() async {
    _audioEntityData = await _db.getAudio(widget.audioId);
    setState(() {
      _audioEntityData = _audioEntityData;
    });
  }

  void navigateToEditAudioScreen(int audioId) {
    Navigator.pushNamed(context, AppRouter.editAudioScreen, arguments: audioId);
  }

  void playAudio(bool isPlay){

    setState(() {
      isPlay == false
          ? isPlayed = true
          : isPlayed = false;
    });
  }

  Future<void> showDeleteAudioDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Audio'),
          content: const Text(
            'Are you sure want to delete this audio ?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteAudio();
                Navigator.pop(context,true);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteAudio(){

    _db.deleteAudio(widget.audioId);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Details"),
        actions: [
          IconButton(onPressed: () {
            navigateToEditAudioScreen(_audioEntityData!.audioId);
          }, icon: const Icon(Icons.edit_outlined)),
          IconButton(onPressed: () {
            showDeleteAudioDialog(context);
          }, icon: const Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: _audioEntityData != null ?
            Column(
              children: [
                Text(
                  _audioEntityData!.audioName,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 20,
                ),
                Slider(
                    max: _audioEntityData!.totalLength!.toDouble(),
                    value: _audioEntityData!.totalLength == 0
                        ? 0
                        : _audioEntityData!.playPosition!.toDouble(),
                    onChanged: null),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: screenHeight * 0.2,
                  width: screenWidth * 0.2,
                  decoration: const BoxDecoration(
                      color: Colors.blue, shape: BoxShape.circle),
                  child: !isPlayed
                  ? IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: (){
                      playAudio(isPlayed);
                    },
                  )
                  : IconButton(
                    icon: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: (){
                      playAudio(isPlayed);
                    },
                  ),
                ),
              ],
            )
            : Container(),
          ),
        ),
      ),
    );
  }
}