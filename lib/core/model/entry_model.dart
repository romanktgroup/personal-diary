import 'package:diary_app/core/database/database_helper.dart';
import 'package:diary_app/core/enum/face_enum.dart';

class Entry {
  final String text;
  final Face face;
  final String? imagePath;
  final DateTime dateTime;
  final int id;

  Entry({
    required this.text,
    required this.face,
    this.imagePath,
    required this.dateTime,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnText: text,
      DatabaseHelper.columnEnum: face.toString().split('.').last,
      DatabaseHelper.columnImagePath: imagePath,
      DatabaseHelper.columnDateTime: dateTime.toIso8601String(),
    };
  }

  static Entry fromMap(Map<String, dynamic> map) {
    print('fromMap: $map');
    return Entry(
      id: map[DatabaseHelper.columnId],
      text: map[DatabaseHelper.columnText],
      face: Face.values.firstWhere((e) => e.toString().split('.').last == map[DatabaseHelper.columnEnum]),
      imagePath: map[DatabaseHelper.columnImagePath],
      dateTime: DateTime.parse(map[DatabaseHelper.columnDateTime]),
    );
  }

  @override
  String toString() {
    return 'Entry{id: $id, text: $text, face: ${face.toString().split('.').last}, imagePath: $imagePath, dateTime: $dateTime}';
  }
}
