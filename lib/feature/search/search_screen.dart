import 'package:diary_app/core/constants/app_svg.dart';
import 'package:diary_app/core/database/database_helper.dart';
import 'package:diary_app/core/helpers/show_snack_bar.dart';
import 'package:diary_app/core/model/entry_model.dart';
import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/theme/app_style.dart';
import 'package:diary_app/core/widget/app_button.dart';
import 'package:diary_app/feature/main/widget/entry_item.dart';
import 'package:diary_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with RouteAware {
  final dbHelper = DatabaseHelper.instance;

  List<Entry> entries = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(searchListener);
  }

  void searchListener() async {
    try {
      final allRows = await dbHelper.searchEntries(controller.text);
      print(allRows);
      setState(() {
        entries = allRows;
      });
    } catch (e) {
      print('error-------');
      print(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    searchListener();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    controller.removeListener(searchListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 45,
              child: TextField(
                controller: controller,
                maxLines: 1,
                style: AppStyle.inputText.copyWith(color: AppColor.inputText),
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  hintStyle: AppStyle.inputText.copyWith(color: AppColor.greyLight),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SvgPicture.asset(AppSvg.search25),
                  ),
                  prefixIconConstraints: const BoxConstraints(maxHeight: 25, maxWidth: 25 + 20 + 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.inputBorder),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 56 + 39 + 39),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(entries[index].id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      color: AppColor.white,
                      child: SvgPicture.asset(AppSvg.delete),
                    ),
                    onDismissed: (direction) async {
                      await dbHelper.delete(entries[index].id);

                      setState(() {
                        entries.removeAt(index);
                      });

                      showSnackBar(context, 'Запись удалена');
                    },
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        return Future.value(true);
                      }
                      return Future.value(false);
                    },
                    child: EntryItem(entry: entries[index]),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 30),
              ),
            ),
            const SizedBox(height: 39),
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
    );
  }
}
