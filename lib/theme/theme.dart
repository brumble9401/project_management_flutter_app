import 'package:flutter/material.dart';
import 'dart:ui';

const MaterialColor Kprimary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFECE8FB),
  100: Color(0xFFD1C5F4),
  200: Color(0xFFB29FED),
  300: Color(0xFF9379E6),
  400: Color(0xFF7B5CE0),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF5C39D7),
  700: Color(0xFF5231D2),
  800: Color(0xFF4829CD),
  900: Color(0xFF361BC4),
});
const int _primaryPrimaryValue = 0xFF643FDB;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFAF9FF),
  200: Color(_primaryAccentValue),
  400: Color(0xFFA293FF),
  700: Color(0xFF8C7AFF),
});
const int _primaryAccentValue = 0xFFCEC6FF;

const primary = Color(0xFF643FDB);
const ascent = Color(0xFFFF8A00);
const neutral_dark = Color(0xFF1C1243);
const neutral_grey = Color(0xFFA29EB6);
const neutral_lightgrey = Color(0xFFEFF1F3);
const white = Color(0xFFFFFFFF);
const semantic_orange = Color(0xFFFF6A5D);
const semantic_green = Color(0xFF47C272);
const overlay_pink = Color(0xFFE15A93);
const overlay_orange = Color(0xFFFF6A5D);
const overlay_purple = Color(0xFFB37BE7);
const overlay_light = Color(0xFFDEEDED);
const overlay_skin = Color(0xFFFFE7CC);
const overlay_lightpink = Color(0xFFF4DE8);
const overlay_stringskin = Color(0xFFFFD7D4);
final overlay_dark = Color(0xFF1C1243).withOpacity(0.8);
