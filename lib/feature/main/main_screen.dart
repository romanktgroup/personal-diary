import 'package:diary_app/core/constants/app_image.dart';
import 'package:diary_app/core/constants/app_svg.dart';
import 'package:diary_app/core/database/database_helper.dart';
import 'package:diary_app/core/model/entry_model.dart';
import 'package:diary_app/core/theme/app_color.dart';
import 'package:diary_app/core/theme/app_style.dart';
import 'package:diary_app/feature/entry/new_entry_screen.dart';
import 'package:diary_app/feature/main/widget/entry_item.dart';
import 'package:diary_app/feature/search/search_screen.dart';
import 'package:diary_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with RouteAware {
  final dbHelper = DatabaseHelper.instance;

  List<Entry> entries = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    try {
      final allRows = await dbHelper.queryAllRows();
      print('Query all rows:');
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
    _loadRecords();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                const SizedBox(height: 25),
                SizedBox(
                  height: 45,
                  child: Row(
                    children: [
                      const SizedBox(width: 24 + 32),
                      const Spacer(),
                      Text(
                        'Главная',
                        style: AppStyle.mainPageTitle.copyWith(color: AppColor.green),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SearchScreen()),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: SvgPicture.asset(AppSvg.search),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
                if (entries.isEmpty) ...[
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
                        child: Image.asset(AppImage.main, fit: BoxFit.cover),
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
                ] else ...[
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100 + 45 + 45),
                      itemCount: entries.length,
                      itemBuilder: (context, index) => EntryItem(entry: entries[index]),
                      separatorBuilder: (context, index) => const SizedBox(height: 30),
                    ),
                  ),
                ],
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewEntryScreen(),
                    ),
                  );
                },
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
            ),
          ],
        ),
      ),
    );
  }
}
