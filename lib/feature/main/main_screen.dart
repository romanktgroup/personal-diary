import 'package:diary_app/core/constants/app_image.dart';
import 'package:diary_app/core/constants/app_svg.dart';
import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/theme/app_style.dart';
import 'package:diary_app/feature/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              height: 45,
              child: Row(
                children: [
                  const SizedBox(width: 24 + 32),
                  const Spacer(),
                  Text(
                    'Главная',
                    style:
                        AppStyle.mainPageTitle.copyWith(color: AppColor.green),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(AppSvg.search),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            const SizedBox(height: 75),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Container(
                height: 308,
                width: 372,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(62),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      color: AppColor.black.withOpacity(.25),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(62),
                  child: Image.asset(
                    AppImage.main,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'Добавьте ваше первое событие!',
                style: AppStyle.mainTitle.copyWith(color: AppColor.green),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.green,
                ),
                alignment: Alignment.center,
                child: Text(
                  '+',
                  style: AppStyle.plus.copyWith(color: AppColor.white),
                ),
              ),
            ),
            const SizedBox(height: 45),
          ],
        ),
      ),
    );
  }
}
