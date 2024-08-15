import 'package:diary_app/core/constants/app_svg.dart';
import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/widget/app_button.dart';
import 'package:diary_app/feature/main/main_screen.dart';
import 'package:diary_app/feature/onboarding/widget/onbording_tile.dart';
import 'package:diary_app/main.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void onTap() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
    await prefs.setBool('onboardingCompleted', true);
  }

  void next() {
    controller.animateToPage(
      (controller.page?.floor() ?? 0) + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                controller: controller,
                children: [
                  OnboardingTile(
                    image: AppSvg.onboarding1,
                    title: 'Добро пожаловать в Мой дневник!',
                    onTap: next,
                  ),
                  OnboardingTile(
                    image: AppSvg.onboarding2,
                    title: 'Создайте свой собственный дневник',
                    text: 'Сохраняйте свою мотивацию и эмоции, уделяя всего 10 минут в день',
                    onTap: next,
                  ),
                  OnboardingTile(
                    image: AppSvg.onboarding1,
                    title: 'Выразите свои чувства:',
                    text: 'Ведь в мире нет ничего лучше, чем понимать себя',
                    onTap: onTap,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 43 + 56 + 40,
              child: Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    dotColor: AppColor.greenLight,
                    activeDotColor: AppColor.green,
                    dotWidth: 16,
                    dotHeight: 12,
                    // strokeWidth: 24,
                    spacing: 10,
                    expansionFactor: 24 / 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
