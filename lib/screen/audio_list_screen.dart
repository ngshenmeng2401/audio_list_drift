import 'package:audio_player_list_with_drift/model/audio_model.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:flutter/material.dart';

class AudioListScreen extends StatefulWidget {
  const AudioListScreen({super.key});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {

  List<AudioModel> audioList = <AudioModel>[
    AudioModel(audioName: "Kangaroo MusiQue", audioURL: "http://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3", start: 0, total: 127),
    AudioModel(audioName: "Sevish", audioURL: "http://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3", start: 0, total: 134),
    AudioModel(audioName: "Music 1", audioURL: "https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_1MB_MP3.mp3", start: 0, total: 43),
    AudioModel(audioName: "Paza Module", audioURL: "http://codeskulptor-demos.commondatastorage.googleapis.com/pang/paza-moduless.mp3", start: 0, total: 179),
  ];

  String _formatDuration(Duration duration) {
    String playedMinutesString = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String playedSecondsString = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$playedMinutesString:$playedSecondsString';
  }

  void navigateToAddAudioScreen(){

    Navigator.pushNamed(context, AppRouter.addAudioScreen);
  }

  void navigateToAudioDetailsScreen(){

    Navigator.pushNamed(context, AppRouter.audioDetailsScreen);
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Audio List"),
        actions: [
          IconButton(
              onPressed: navigateToAddAudioScreen,
              icon: const Icon(
                  Icons.add_circle_rounded
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: screenHeight * 0.9,
          child:
          audioList.length != null
          ? ListView.builder(
              itemCount: audioList.length,
              itemBuilder: (context, index){
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  child: ListTile(
                    onTap: navigateToAudioDetailsScreen,
                    title: Text(audioList[index].audioName!),
                    subtitle: Text("${audioList[index].start!} - ${_formatDuration(Duration(seconds: audioList[index].total!))}"),
                    trailing: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: IconButton(
                        icon: const Icon(
                            color: Colors.black,
                            Icons.play_arrow
                        ),
                        onPressed: (){},
                      ),
                    ),
                  ),
                ),);
              })
          : Container(),
        ),
      ),
    );
  }
}
