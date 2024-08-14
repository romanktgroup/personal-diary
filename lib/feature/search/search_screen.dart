import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/widget/app_button.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 49),
            child: AppButton(
              title: 'назад'.toUpperCase(),
              color: AppButtonColor.outline,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(height: 39),
        ],
      ),
    );
  }
}
