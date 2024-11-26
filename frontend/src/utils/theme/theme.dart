import 'package:flutter/material.dart';
import '../theme/custom_themes/text_theme.dart';

import '../theme/custom_themes/bottom_sheet_theme.dart';
import '../theme/custom_themes/checkbox_theme.dart';
import '../theme/custom_themes/chip_theme.dart';
import '../theme/custom_themes/elevated_button_theme.dart';
import '../theme/custom_themes/text_field_theme.dart';

class TAppTheme{
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Arial',
    brightness: Brightness.light,
    primaryColor: Colors.indigo,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Arial',
    brightness: Brightness.dark,
    primaryColor: Colors.indigo,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.black,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
  );
}