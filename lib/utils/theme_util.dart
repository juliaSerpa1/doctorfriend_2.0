import 'package:flutter/material.dart';

class ThemeUtil {
  static ThemeData light([double fontSize = 0.0]) {
    const Color onColor = Colors.white;
    const Color primary = Color.fromRGBO(6, 67, 192, 1);
    const Color onPrimary = onColor;
    const Color secondary = Color.fromRGBO(128, 225, 107, 1);
    const Color onSecondary = Color.fromRGBO(55, 55, 55, 1);
    const Color secondaryContainer = Color.fromRGBO(69, 186, 67, 1);
    const Color tertiary = Colors.grey;
    const Color onTertiary = onColor;
    final Color tertiaryContainer = Colors.greenAccent.shade700;
    final Color error = Colors.redAccent.shade400;
    const Color background = Color.fromRGBO(240, 240, 240, 1);
    const Color onBackground = Color.fromRGBO(0, 0, 0, 1);
    return _theme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      fontSize: fontSize,
      tertiaryContainer: tertiaryContainer,
      error: error,
      background: background,
      onBackground: onBackground,
    );
  }

  static ThemeData dark([double fontSize = 0.0]) {
    const Color onColor = Colors.white;
    const Color primary = Colors.grey;
    const Color onPrimary = onColor;
    final Color secondary = Colors.teal.shade600;
    const Color onSecondary = onColor;
    const Color tertiary = Colors.grey;
    const Color onTertiary = onColor;
    final Color tertiaryContainer = Colors.greenAccent.shade700;
    const Color background = Color.fromRGBO(48, 48, 48, 1);
    const Color onBackground = Color.fromRGBO(200, 200, 200, 1);
    return _theme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      tertiary: tertiary,
      onTertiary: onTertiary,
      fontSize: fontSize,
      tertiaryContainer: tertiaryContainer,
      background: background,
      onBackground: onBackground,
      // textColor: textColor,
    );
  }

  static ThemeData _theme({
    required Brightness brightness,
    Color? canvasColor,
    required Color primary,
    required Color onPrimary,
    Color? primaryContainer,
    required Color secondary,
    required Color onSecondary,
    Color? secondaryContainer,
    required Color tertiary,
    required Color onTertiary,
    Color? tertiaryContainer,
    Color error = Colors.redAccent,
    Color? onError,
    Color? errorContainer,
    Color? background,
    Color? onBackground,
    required double fontSize,
  }) {
    final double fontVerySmall = 14.0 + fontSize;
    final double fontSmall = 15.0 + fontSize;
    final double fontMedium = 16.0 + fontSize;
    final double fontLarge = 19.0 + fontSize;
    const double fontVeryLarge = 22.0;

    const double circular = 26.0;

    OutlineInputBorder inputBorder(bool selected) {
      return OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: selected ? primary.withOpacity(.5) : secondary.withOpacity(.5),
        ),
        borderRadius: BorderRadius.circular(circular),
      );
    }

    // final bool isDark = brightness == Brightness.dark;

    final ThemeData theme = ThemeData(
      canvasColor: canvasColor,
      appBarTheme: AppBarTheme(
        // shape: ContinuousRectangleBorder(
        //   side: BorderSide(
        //     color: primary.withOpacity(.5),
        //     width: .5,
        //   ),
        // ),
        color: onBackground,
        // shadowColor: const Color.fromRGBO(0, 0, 0, 0),
        centerTitle: true,
        elevation: 10,
        titleTextStyle: TextStyle(
          fontSize: fontLarge,
          color: onPrimary,
        ),
        iconTheme: IconThemeData(
          color: onPrimary,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        yearBackgroundColor: MaterialStateProperty.resolveWith((_) => tertiary),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: secondary,
        labelColor: onSecondary,
        dividerColor: onSecondary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: fontMedium,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: fontMedium,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        iconSize: 35.0 + fontSize,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
          backgroundColor: secondary,
          foregroundColor: onSecondary,
          textStyle: TextStyle(
            fontSize: fontLarge,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circular),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          color: onSecondary,
          fontWeight: FontWeight.w500,
          fontSize: fontMedium,
        ),
        subtitleTextStyle: TextStyle(
          color: onBackground?.withOpacity(.7),
          fontWeight: FontWeight.w300,
          fontSize: fontSmall,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: TextStyle(
            fontSize: fontMedium,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
        enabledBorder: inputBorder(false),
        focusedBorder: inputBorder(true),
        border: inputBorder(true),
        errorStyle: TextStyle(
          fontSize: fontVerySmall,
        ),
        hintStyle: TextStyle(
          color: onSecondary.withOpacity(.4),
          fontWeight: FontWeight.w300,
        ),
        labelStyle: TextStyle(
          color: onSecondary.withOpacity(.6),
          fontWeight: FontWeight.w400,
          fontSize: fontLarge,
        ),
      ),
      checkboxTheme: const CheckboxThemeData(
        side: BorderSide(
          width: 1,
        ),
      ),
      colorScheme: ThemeData().colorScheme.copyWith(
            brightness: brightness,
            primary: primary,
            onPrimary: onPrimary,
            primaryContainer: primaryContainer,
            secondary: secondary,
            onSecondary: onSecondary,
            secondaryContainer: secondaryContainer,
            tertiary: tertiary,
            onTertiary: onTertiary,
            tertiaryContainer: tertiaryContainer,
            error: error,
            onError: onError,
            errorContainer: errorContainer,
            background: background,
            onBackground: onBackground,
          ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: fontVeryLarge + fontSize,
          fontWeight: FontWeight.w500,
          color: onSecondary,
        ),
        titleLarge: TextStyle(
          fontSize: fontLarge + fontSize,
          fontWeight: FontWeight.w500,
          color: onSecondary,
        ),
        titleMedium: TextStyle(
          fontSize: fontMedium + fontSize,
          fontWeight: FontWeight.w500,
          color: onSecondary,
        ),
        titleSmall: TextStyle(
          fontSize: fontSmall + fontSize,
          fontWeight: FontWeight.w500,
          color: onSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: fontLarge + fontSize,
          fontWeight: FontWeight.w400,
          // color: onPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: fontMedium + fontSize,
          fontWeight: FontWeight.w400,
          // color: onPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: fontVerySmall + fontSize,
          fontWeight: FontWeight.w300,
        ),
      ),
    );

    return theme;
  }
}
