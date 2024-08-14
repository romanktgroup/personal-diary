import 'dart:io';

import 'package:diary_app/core/constants/app_svg.dart';
import 'package:diary_app/core/database/database_helper.dart';
import 'package:diary_app/core/enum/face_enum.dart';
import 'package:diary_app/core/model/entry_model.dart';
import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/theme/app_style.dart';
import 'package:diary_app/core/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({
    super.key,
    this.entry,
    required this.refreshParent,
  });

  final Entry? entry;
  final VoidCallback? refreshParent;

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  late final controller = TextEditingController(text: widget.entry?.text);

  late Face selectedFace = widget.entry?.face ?? Face.poker;

  XFile? image;

  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  loadImage() async {
    final path = widget.entry?.imagePath;
    if (path == null) return;

    final file = await loadImageFromPath(path);

    if (file == null) return;

    setState(() {
      image = file;
    });
  }

  Future<XFile?> loadImageFromPath(String imagePath) async {
    try {
      // Создаем объект XFile из локального пути
      XFile imageFile = XFile(imagePath);
      return imageFile;
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  void _saveRecord(BuildContext context) async {
    if (controller.text.isEmpty) return;

    final String? imagePath = await saveImage();

    Map<String, dynamic> row = {
      DatabaseHelper.columnText: controller.text,
      DatabaseHelper.columnEnum: selectedFace,
      DatabaseHelper.columnImagePath: imagePath ?? '',
      DatabaseHelper.columnDateTime: (widget.entry?.dateTime ?? DateTime.now()).toIso8601String(),
    };

    if (widget.entry == null) {
      final id = await dbHelper.insert(row);
      print('Inserted row id: $id');
    } else {
      row[DatabaseHelper.columnId] = widget.entry!.id;
      final id = await dbHelper.update(row);
      print('Updated row id: $id');
    }
    widget.refreshParent?.call();
    Navigator.of(context).pop();
  }

  Future<String?> saveImage() async {
    String? imagePath;

    if (image == null) return null;

    Directory directory = await getApplicationDocumentsDirectory();

    // Получаем текущее время в микросекундах
    String timestamp = DateTime.now().microsecondsSinceEpoch.toString();

    // Извлекаем расширение файла (например, .png, .jpg)
    String extension = path.extension(image!.name);

    // Создаем уникальное имя файла, сохраняя только расширение
    String uniqueFileName = '$timestamp$extension';

    imagePath = path.join(directory.path, uniqueFileName);
    await image!.saveTo(imagePath);

    return imagePath;
  }

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
                maxLines: 6,
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
                  (index) {
                    final face = Face.values[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFace = face;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Opacity(
                        opacity: selectedFace == face ? .2 : 1,
                        child: SvgPicture.asset(
                          face.icon,
                          height: 40,
                          width: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 58),
              AppButton(
                title: 'добавить фото+'.toUpperCase(),
                size: AppButtonSize.small,
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? tmp = await picker.pickImage(source: ImageSource.gallery);
                  if (tmp == null) return;
                  setState(() {
                    image = tmp;
                  });
                },
              ),
              image == null
                  ? const Spacer()
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              image = null;
                            });
                          },
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                File(image!.path),
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: SvgPicture.asset(AppSvg.deleteSmall),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 49),
                child: AppButton(
                  title: 'сохранить'.toUpperCase(),
                  onTap: () => _saveRecord(context),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 49),
                child: AppButton(
                  title: 'назад'.toUpperCase(),
                  color: AppButtonColor.outline,
                  onTap: () {
                    Navigator.of(context).pop(true);
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
