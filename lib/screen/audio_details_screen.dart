import 'package:flutter/material.dart';

class AudioDetailsScreen extends StatefulWidget {
  const AudioDetailsScreen({super.key});

  @override
  State<AudioDetailsScreen> createState() => _AudioDetailsScreenState();
}

class _AudioDetailsScreenState extends State<AudioDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Details"),
      ),
      body: SingleChildScrollView(
        child: Center(),
      ),
    );
  }
}
