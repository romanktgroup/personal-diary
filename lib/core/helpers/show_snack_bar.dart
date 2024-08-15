import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/theme/app_style.dart';
import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppStyle.startText.copyWith(color: AppColor.green),
        ),
      ),
    );
