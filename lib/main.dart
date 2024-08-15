import 'package:diary_app/feature/main/main_screen.dart';
import 'package:diary_app/feature/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

late final SharedPreferences prefs;
void main() async {
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      // screen width used in your UI design
      const double widthOfDesign = 414;
      return deviceSize.width / widthOfDesign;
    },
  );

  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorObservers: [routeObserver],
      home: onboardingCompleted ? const MainScreen() : const OnboardingScreen(),
    );
  }
}
