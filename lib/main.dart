import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app_turtle/features/views/onboarding_screen.dart';
import 'package:to_do_app_turtle/root.dart';
import 'package:to_do_app_turtle/utils/colors.dart';
import 'features/view_model/get_data_view_model.dart';
import 'features/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var providers = [
      ChangeNotifierProvider<GetDataViewModel>(
          create: (context) => GetDataViewModel()),
    ];
    return MultiProvider(
        providers: providers,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            title: 'To do List',
            theme: AppTheme.primaryTheme,
            home: const Root()));
  }
}
