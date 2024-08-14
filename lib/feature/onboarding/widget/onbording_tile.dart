import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingTile extends StatelessWidget {
  const OnboardingTile({
    super.key,
    required this.image,
    required this.title,
    this.text,
  });

  final String image;
  final String title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SvgPicture.asset(image, width: 330),
          ),
          const Spacer(),
          SizedBox(
            height: 146,
            child: Column(
              children: [
                Text(
                  title,
                  style: AppStyle.startTitle.copyWith(color: AppColor.green),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  text ?? '',
                  style: AppStyle.startText.copyWith(color: AppColor.greyLight),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
