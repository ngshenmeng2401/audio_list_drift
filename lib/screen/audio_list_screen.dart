import 'package:audio_player_list_with_drift/db/app_db.dart';
import 'package:audio_player_list_with_drift/model/audio_model.dart';
import 'package:audio_player_list_with_drift/route/app_route.dart';
import 'package:audio_player_list_with_drift/screen/audio_details_screen.dart';
import 'package:flutter/material.dart';

class AudioListScreen extends StatefulWidget {
  const AudioListScreen({super.key});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {

  late AppDb _db;
  List<bool> isPlayedList = [];
  List<AudioEntityData>? audioList;

  @override
  void initState() {
    super.initState();

    _db = AppDb();
    getAudioListData();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String playedMinutesString = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String playedSecondsString = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$playedMinutesString:$playedSecondsString';
  }

  void navigateToAddAudioScreen(){

    Navigator.pushNamed(context, AppRouter.addAudioScreen).then((value) => (){
      setState(() {
        getAudioListData();
      });
    });
  }

  Future<void> navigateToAudioDetailsScreen(int audioId) async {

    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => AudioDetailsScreen(audioId: audioId)),
    ).then((value) => (){
      setState(() {
        getAudioListData();
      });
    });

    if(result != null && result == true){
      setState(() {
        getAudioListData();
      });
    }
  }

  Future<void> getAudioListData() async {
    audioList = await _db.getAudioList();

    if(audioList != null){
      for(int i = 0 ; i < audioList!.length ; i++){
        isPlayedList.insert(i, false);
      }
    }

    print("isPlayedList: $isPlayedList");
  }

  void playAudio(bool isPlayed, int index){

    setState(() {
      isPlayed == true
          ? isPlayedList[index] = false
          : isPlayedList[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio List"),
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
          child: FutureBuilder<List<AudioEntityData>>(
            future: _db.getAudioList(),
            builder: (context, snapshot){
              final List<AudioEntityData>? audioList = snapshot.data;

              if(snapshot.connectionState != ConnectionState.done){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if(snapshot.hasError){
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if(audioList != null){

                return ListView.builder(
                    itemCount: audioList.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          child: ListTile(
                            onTap: (){
                              navigateToAudioDetailsScreen(audioList[index].audioId);
                            },
                            title: Text(audioList[index].audioName),
                            subtitle: Text("0 - ${_formatDuration(Duration(seconds: audioList[index].totalLength!))}"),
                            trailing: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: !isPlayedList[index]
                              ? IconButton(
                                icon: const Icon(
                                    color: Colors.white,
                                    Icons.play_arrow,
                                ),
                                onPressed: (){
                                  playAudio(isPlayedList[index], index);
                                },
                              )
                              : IconButton(
                                icon: const Icon(
                                    color: Colors.white,
                                    Icons.pause
                                ),
                                onPressed: (){
                                  playAudio(isPlayedList[index], index);
                                },
                              ),
                            ),
                          ),
                        ),);
                    });
              }
              return Container();
            },
          )

        ),
      ),
    );
  }
}
