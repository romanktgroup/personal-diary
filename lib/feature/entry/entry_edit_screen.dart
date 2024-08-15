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
import 'package:scaled_app/scaled_app.dart';

class EntryEditScreen extends StatefulWidget {
  const EntryEditScreen({
    super.key,
    this.entry,
  });

  final Entry? entry;

  @override
  State<EntryEditScreen> createState() => _EntryEditScreenState();
}

class _EntryEditScreenState extends State<EntryEditScreen> {
  late final controller = TextEditingController(text: widget.entry?.text);

  late Face selectedFace = widget.entry?.face ?? Face.poker;

  List<XFile> images = [];

  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  loadImages() async {
    final paths = widget.entry?.imagePath ?? [];
    for (final path in paths) {
      if (await checkIfFileExists(path)) {
        final file = await loadImageFromPath(path);
        if (file != null) {
          setState(() {
            images.add(file);
          });
        }
      }
    }
  }

  Future<XFile?> loadImageFromPath(String imagePath) async {
    try {
      XFile imageFile = XFile(imagePath);
      return imageFile;
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  Future<bool> checkIfFileExists(String path) async {
    final file = File(path);
    return await file.exists();
  }

  void _saveRecord(BuildContext context) async {
    if (controller.text.isEmpty) return;

    List<String> imagePaths = [];
    for (final image in images) {
      final imagePath = await saveImage(image);
      if (imagePath != null) {
        imagePaths.add(imagePath);
      }
    }

    Map<String, dynamic> row = {
      DatabaseHelper.columnText: controller.text,
      DatabaseHelper.columnEnum: selectedFace,
      DatabaseHelper.columnImagePath: imagePaths.join(','),
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
    Navigator.of(context).pop();
  }

  Future<String?> saveImage(XFile image) async {
    Directory directory = await getApplicationDocumentsDirectory();

    String timestamp = DateTime.now().microsecondsSinceEpoch.toString();

    String extension = path.extension(image.name);

    String uniqueFileName = '$timestamp$extension';

    String imagePath = path.join(directory.path, uniqueFileName);
    await image.saveTo(imagePath);

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
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).scale().size.height -
                MediaQuery.of(context).scale().padding.top -
                MediaQuery.of(context).scale().padding.bottom,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
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
                const SizedBox(height: 24),
                AppButton(
                  title: 'добавить фото+'.toUpperCase(),
                  size: AppButtonSize.small,
                  onTap: () async {
                    if (images.length >= 5) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Можно добавить максимум 5 изображений!',
                            style: AppStyle.startText.copyWith(color: AppColor.green),
                          ),
                        ),
                      );
                      return;
                    }
                    final ImagePicker picker = ImagePicker();
                    final XFile? tmp = await picker.pickImage(source: ImageSource.gallery);
                    if (tmp == null) return;
                    setState(() {
                      images.add(tmp);
                    });
                  },
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.file(
                                  File(images[index].path),
                                  fit: BoxFit.contain,
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        images.removeAt(index);
                                      });
                                    },
                                    child: SvgPicture.asset(AppSvg.deleteSmall),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(width: 20),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 25),
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
      ),
    );
  }
}
