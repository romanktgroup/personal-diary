import 'package:diary_app/core/enum/face_enum.dart';
import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/theme/app_style.dart';
import 'package:diary_app/core/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final controller = TextEditingController();

  int selectedFace = 0;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.green),
      borderRadius: BorderRadius.circular(12),
    );
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              SizedBox(
                height: 45,
                child: Row(
                  children: [
                    const SizedBox(height: 25),
                    Text(
                      'Мои эмоции',
                      style: AppStyle.mainPageTitle.copyWith(color: AppColor.green),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Описание',
                style: AppStyle.smallTitle.copyWith(color: AppColor.green),
              ),
              const SizedBox(height: 11),
              TextField(
                controller: controller,
                minLines: 4,
                maxLines: 10,
                style: AppStyle.inputText.copyWith(color: AppColor.black),
                decoration: InputDecoration(
                  border: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  errorBorder: outlineInputBorder,
                  enabledBorder: outlineInputBorder,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Значок события',
                style: AppStyle.smallTitle.copyWith(color: AppColor.green),
              ),
              const SizedBox(height: 11),
              Wrap(
                spacing: 25,
                runSpacing: 18,
                children: List.generate(
                  Face.values.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFace = index;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Opacity(
                      opacity: selectedFace == index ? .2 : 1,
                      child: SvgPicture.asset(
                        Face.values[index].icon,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 58),
              AppButton(
                title: 'добавить фото+'.toUpperCase(),
                size: AppButtonSize.small,
                onTap: () {},
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 49),
                child: AppButton(
                  title: 'сохранить'.toUpperCase(),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 20),
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
        ),
      ),
    );
  }
}
