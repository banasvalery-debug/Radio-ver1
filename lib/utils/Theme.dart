import 'dart:ui';

class Theme {
  Map<String, dynamic> light = {
    'splashBackground': Color(0xff0097FF),
    'textGrey': Color(0xff6B727B),
    'textDark': Color(0xff161616),
    'background': Color(0xffffffff),
    'secondaryColor': Color(0xffEAEEF2),
    'primaryColor': Color(0xff0097FF),
  };

  Map<String, dynamic> dark = {
    'splashBackground': Color(0xff0097FF),
    'textGrey': Color(0xff6B727B),
    'textDark': Color(0xff161616),
    'background': Color(0xffffffff),
    'secondaryColor': Color(0xffEAEEF2),
    'primaryColor': Color(0xff0097FF),
  };
  bool isDark = false;

  Color getColor(String name) {
    return isDark ? dark[name] : light[name];
  }
}
