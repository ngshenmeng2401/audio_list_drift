import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
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

  @override
  void initState() {
    _db = AppDb();
    getAudioData();

    // TODO: implement initState
    super.initState();
  }

  Future<void> getAudioData() async {
    _audioEntityData = await _db.getAudio(widget.audioId);
  }

  void navigateToEditAudioScreen(int audioId) {
    Navigator.pushNamed(context, AppRouter.editAudioScreen, arguments: audioId);
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
          const IconButton(onPressed: null, icon: Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
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
                  child: const IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
