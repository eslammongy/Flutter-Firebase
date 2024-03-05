import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/theme/dark_palette.dart';
import 'package:flutter_firebase/core/theme/error_palette.dart';
import 'package:flutter_firebase/core/theme/light_palette.dart';
import 'package:flutter_firebase/core/theme/common_palette.dart';

ThemeData getDarkThemeData() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: DarkPalette.backgroundDarkColor,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: CommonColorPalette.mainBlueColor,
        onPrimary: CommonColorPalette.greenColor,
        secondary: CommonColorPalette.mainOrangeColor,
        onSecondary: CommonColorPalette.greenColor,
        error: ErrorPalette.normal,
        onError: ErrorPalette.dark,
        background: DarkPalette.backgroundDarkColor,
        onBackground: DarkPalette.backgroundNormalColor,
        surface: DarkPalette.surfaceNormal,
        onSurface: DarkPalette.onSurfaceDark,
        outline: DarkPalette.outLineDark,
        tertiary: DarkPalette.tertiaryDarkColor,
        onTertiary: DarkPalette.onTertiaryColor,
        tertiaryContainer: DarkPalette.tertiaryContainer,
        surfaceTint: DarkPalette.surfaceTintColor,
        scrim: DarkPalette.scrim,
      ),
    );

ThemeData getLightThemeData() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: LightPalette.backgroundLightColor,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: CommonColorPalette.mainBlueColor,
      onPrimary: CommonColorPalette.greenColor,
      secondary: CommonColorPalette.mainOrangeColor,
      onSecondary: CommonColorPalette.greenColor,
      error: ErrorPalette.normal,
      onError: ErrorPalette.dark,
      background: LightPalette.backgroundNormalColor,
      onBackground: LightPalette.backgroundLightColor,
      surface: LightPalette.surfaceNormal,
      onSurface: LightPalette.onSurfaceLight,
      outline: LightPalette.outLineLight,
      tertiary: LightPalette.tertiaryLightColor,
      onTertiary: LightPalette.onTertiaryColor,
      tertiaryContainer: LightPalette.tertiaryContainer,
      surfaceTint: LightPalette.surfaceTintColor,
      scrim: LightPalette.scrim,
    ));
