import 'package:diary_app/feature/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() {
  runAppScaled(
    const MyApp(),
    scaleFactor: (deviceSize) {
      // screen width used in your UI design
      const double widthOfDesign = 414;
      return deviceSize.width / widthOfDesign;
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorObservers: [routeObserver],
      home: const OnboardingScreen(),
    );
  }
}
