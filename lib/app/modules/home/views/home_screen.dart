import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitch/app/modules/home/controllers/auth_controller.dart';
import 'package:twitch/app/modules/home/controllers/user_controller.dart';
import 'package:twitch/app/modules/home/views/go_live_screen.dart';
import 'package:twitch/app/modules/home/views/profile_infor.dart';

import '../../../data/constants/constants.dart';
import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  List<Widget> pages = [
    const FeedScreen(),
    const GoLiveScreen(),
    ProfileInfo()
  ];

  onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: CustomColors.buttonColor,
        unselectedItemColor: CustomColors.backgroundColor,
        backgroundColor: CustomColors.primaryColor,
        unselectedFontSize: 12,
        onTap: onPageChange,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_rounded,
            ),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.copy,
            ),
            label: 'Browse',
          ),
        ],
      ),
      body: pages[_page],
    );
  }
}
