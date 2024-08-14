import 'package:diary_app/feature/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';

void main() {
  runAppScaled(const MyApp(), scaleFactor: (deviceSize) {
    // screen width used in your UI design
    const double widthOfDesign = 414;
    return deviceSize.width / widthOfDesign;
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}
