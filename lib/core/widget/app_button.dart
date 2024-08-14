import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/theme/app_style.dart';
import 'package:flutter/material.dart';

enum AppButtonColor { green, outline }

enum AppButtonSize { normal, small }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.size = AppButtonSize.normal,
    this.color = AppButtonColor.green,
    this.width = double.infinity,
  });

  final String title;
  final VoidCallback onTap;
  final AppButtonColor color;
  final AppButtonSize size;
  final double width;

  @override
  Widget build(BuildContext context) {
    final double height = size == AppButtonSize.normal ? 56 : 37;
    final backgroundColor =
        color == AppButtonColor.green ? AppColor.green : AppColor.white;
    final textColor =
        color == AppButtonColor.green ? AppColor.white : AppColor.green;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: AppColor.green),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppStyle.buttonTitle.copyWith(color: textColor),
        ),
      ),
    );
  }
}
