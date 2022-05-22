import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/views/home.dart';
import 'features/views/onboarding_screen.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var storage = await SharedPreferences.getInstance();
      isOnBoardingSeen = storage.getBool("isOnBoardingSeen") ?? false;
      if (isOnBoardingSeen) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen()),
            (Route<dynamic> route) => false);
      }
    });
  }

  bool isOnBoardingSeen = true;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
