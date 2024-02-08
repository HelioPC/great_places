import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_places/src/common/extensions/custom_theme_extension.dart';
import 'package:great_places/src/common/utils/my_colors.dart';

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark(useMaterial3: true);

  return base.copyWith(
    colorScheme: const ColorScheme.dark(
      background: MyColors.black87,
      primary: MyColors.green,
      brightness: Brightness.dark,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Poppins',
    ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Poppins',
    ),
    scaffoldBackgroundColor: MyColors.black87,
    extensions: [CustomThemeExtension.darkMode],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.green,
        foregroundColor: Colors.black,
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: MyColors.grey600,
      modalBackgroundColor: MyColors.grey600,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),
    dialogBackgroundColor: MyColors.grey600,
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MyColors.green,
      foregroundColor: Colors.black,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.red,
      tileColor: Colors.grey.withOpacity(.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 12,
        color: MyColors.grey,
      ),
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: MaterialStatePropertyAll(MyColors.grey),
      trackColor: MaterialStatePropertyAll(Color(0xFF344047)),
    ),
  );
}