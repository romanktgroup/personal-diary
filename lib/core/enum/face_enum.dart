import 'package:diary_app/core/constants/app_svg.dart';

enum Face {
  poker,
  stupid,
  happy,
  happy2,
  inLove,
  getIll,
  jealous,
  sinister,
  think,
  tounge,
  dizziness,
  cool,
}

extension WeatherExtension on Face {
  String get icon {
    return switch (this) {
      Face.poker => AppSvg.poker,
      Face.stupid => AppSvg.stupid,
      Face.happy => AppSvg.happy,
      Face.happy2 => AppSvg.happy2,
      Face.inLove => AppSvg.inLove,
      Face.getIll => AppSvg.getIll,
      Face.jealous => AppSvg.jealous,
      Face.sinister => AppSvg.sinister,
      Face.think => AppSvg.think,
      Face.tounge => AppSvg.tounge,
      Face.dizziness => AppSvg.dizziness,
      Face.cool => AppSvg.cool,
    };
  }
}
