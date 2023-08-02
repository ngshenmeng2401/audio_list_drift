import 'package:audio_player_list_with_drift/screen/get_it/audio_list_get_it_screen.dart';
import 'package:audio_player_list_with_drift/screen/provider/audio_list_provider_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  late List<Widget> _tabs;
  int _currentIndex = 0;

  @override
  void initState() {

    super.initState();
    _tabs = [
      const AudioListWithProviderScreen(),
      const AudioListWithGetItScreen(),
    ];
  }

  void _onItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int index = _currentIndex;

    return Scaffold(
      body: _tabs.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 18,),
            label: "Stream Provider",
            activeIcon: Icon(Icons.home, size: 26,)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 18,),
              label: "Stream Get It",
              activeIcon: Icon(Icons.home, size: 26,)
          ),
          // BottomNavigationBarItem(
          //   icon: Container(
          //     margin: const EdgeInsets.only(bottom: 2.0),
          //     child: Image.asset(
          //       'assets/icons/icon_course.png',
          //       width: 24,
          //       height: 24,
          //     ),
          //   ),
          //   activeIcon: Container(
          //     margin: const EdgeInsets.only(bottom: 2.0),
          //     child: Image.asset(
          //       'assets/icons/icon_course_selected.png',
          //       width: 24,
          //       height: 24,
          //     ),
          //   ),
          //   label: Lang.of(context).course_text,
          // ),
        ],
        currentIndex: index,
        onTap: _onItemTap,
      ),
    );
  }
}
