import 'dart:io';

import 'package:diary_app/core/database/database_helper.dart';
import 'package:diary_app/core/enum/face_enum.dart';
import 'package:diary_app/core/model/entry_model.dart';
import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/theme/app_style.dart';
import 'package:diary_app/core/widget/app_button.dart';
import 'package:diary_app/feature/entry/entry_edit_screen.dart';
import 'package:diary_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class EntryViewScreen extends StatefulWidget {
  const EntryViewScreen({
    super.key,
    required this.entry,
  });
  final Entry entry;

  @override
  State<EntryViewScreen> createState() => _EntryViewScreenState();
}

class _EntryViewScreenState extends State<EntryViewScreen> with RouteAware {
  late Entry entry = widget.entry;
  List<XFile> images = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  initState() {
    super.initState();
    reloadEntry();
  }

  reloadEntry() async {
    print('reloadEntry');
    final newEntry = await dbHelper.loadEntryById(entry.id);
    print(newEntry);
    if (newEntry == null) return;
    entry = newEntry;
    setState(() {});

    loadImages();
  }

  loadImages() async {
    images = [];
    final paths = entry.imagePath;
    for (final path in paths) {
      if (await checkIfFileExists(path)) {
        final file = await loadImageFromPath(path);
        if (file != null) {
          images.add(file);
        }
      }
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print('didPopNext');
    reloadEntry();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Expanded(
                child: ListView(
                  children: [
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
                    Text(
                      entry.text,
                      style: AppStyle.inputText.copyWith(color: AppColor.black),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Значок события',
                      style: AppStyle.smallTitle.copyWith(color: AppColor.green),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      children: [
                        SvgPicture.asset(
                          entry.face.icon,
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    images.isEmpty
                        ? const SizedBox.shrink()
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: images.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Image.file(
                                File(images[index].path),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(height: 20),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 49),
                child: AppButton(
                  title: 'изменить'.toUpperCase(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntryEditScreen(entry: entry),
                      ),
                    );
                  },
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
