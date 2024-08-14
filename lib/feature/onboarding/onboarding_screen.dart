import 'package:diary_app/core/constants/app_svg.dart';
import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/widget/app_button.dart';
import 'package:diary_app/feature/onboarding/widget/onbording_tile.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 550,
              child: PageView(
                controller: controller,
                children: const [
                  OnboardingTile(
                    image: AppSvg.onboarding1,
                    title: 'Добро пожаловать в Мой дневник!',
                  ),
                  OnboardingTile(
                    image: AppSvg.onboarding2,
                    title: 'Создайте свой собственный дневник',
                    text:
                        'Сохраняйте свою мотивацию и эмоции, уделяя всего 10 минут в день',
                  ),
                  OnboardingTile(
                    image: AppSvg.onboarding1,
                    title: 'Выразите свои чувства:',
                    text: 'Ведь в мире нет ничего лучше, чем понимать себя',
                  ),
                ],
              ),
            ),
            const Spacer(),
            SmoothPageIndicator(
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: AppButton(
                title: 'Продолжить'.toUpperCase(),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 43),
          ],
        ),
      ),
    );
  }
}
