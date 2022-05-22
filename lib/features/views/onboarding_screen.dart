import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/colors.dart';
import '../../utils/string_resources.dart';
import '../view_model/get_data_view_model.dart';
import 'home.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  Timer? _timer;
  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var vm = GetDataViewModel.read(context);
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      vm.resetSelectedImage();
    });
    if (vm.selectedImage < 2) {
      _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        if (vm.selectedImage < 2) {
          vm.selectedImage++;
        }
        if (vm.selectedImage < 3) {
          pageController.animateToPage(
            vm.selectedImage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var spaceBetween = const SizedBox(
      height: 10,
    );
    Widget onBoardingElement({String? title, String? imagePath}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Column(
            children: [
              Text(title!,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor)),
              spaceBetween,
              Image.asset(
                imagePath!,
                height: width < 360 ? 250 : 350,
                width: width,
                fit: BoxFit.cover,
              ),
            ],
          ),
          const SizedBox(),
          const SizedBox(),
        ],
      );
    }

    var vm = GetDataViewModel.watch(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (context) => const Home()));
              var storage = await SharedPreferences.getInstance();
              storage.setBool("isOnBoardingSeen", true);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(StringResources.skipText,
                  style: TextStyle(color: AppTheme.primaryColor)),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 0.0, left: 0),
            child: PageView(
              controller: pageController,
              onPageChanged: (val) {
                vm.selectedImage = val;
              },
              //reverse: true,
              children: [
                onBoardingElement(
                    imagePath: "assets/onboarding_1.png",
                    title: StringResources.welcomeText),
                onBoardingElement(
                    imagePath: "assets/onboarding_2.png",
                    title: StringResources.addYourTaskText),
                onBoardingElement(
                    imagePath: "assets/onboarding_3.png",
                    title: StringResources.completedText),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: width < 360 ? 11 : 13,
                              width: width < 360 ? 11 : 13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: vm.selectedImage == 0
                                      ? AppTheme.primaryColor
                                      : Colors.transparent,
                                  border: Border.all()),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: width < 360 ? 11 : 13,
                              width: width < 360 ? 11 : 13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: vm.selectedImage == 1
                                      ? AppTheme.primaryColor
                                      : Colors.transparent,
                                  border: Border.all()),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: width < 360 ? 11 : 13,
                              width: width < 360 ? 11 : 13,
                              decoration: BoxDecoration(
                                  color: vm.selectedImage == 2
                                      ? AppTheme.primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all()),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (vm.selectedImage < 3) {
                              vm.selectedImage++;
                            }
                            pageController.jumpToPage(vm.selectedImage);
                            if (vm.selectedImage == 3) {
                              var storage =
                                  await SharedPreferences.getInstance();
                              storage.setBool("isOnBoardingSeen", true);
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Home()));
                            }
                          },
                          child: Container(
                            height: width < 360 ? 35 : 40,
                            width: width < 360 ? 35 : 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppTheme.primaryColor),
                            child: Icon(Icons.arrow_forward_ios_outlined,
                                size: width < 360 ? 18 : 20),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: width < 360 ? 30 : 50,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
