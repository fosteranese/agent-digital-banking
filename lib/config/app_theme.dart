import 'package:flutter/material.dart';
import 'package:my_sage_agent/constants/app_colors.dart';
import 'package:my_sage_agent/constants/app_sizes.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: PrimaryTextStyle().fontFamily,
      fontFamilyFallback: PrimaryTextStyle().fontFamilyFallback,
      primaryColorDark: AppColors.primaryDark,
      primaryColorLight: AppColors.primaryLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.black,
        primary: AppColors.black,
        secondary: ThemeUtil.secondaryColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: TextTheme(
        bodySmall: PrimaryTextStyle(
          color: AppColors.textLight,
          fontWeight: FontWeight.w400,
          fontSize: AppFontSizes.small,
        ),
        displaySmall: PrimaryTextStyle(
          fontWeight: FontWeight.w400,
          fontSize: AppFontSizes.small,
          color: AppColors.textMuted,
        ),
        labelSmall: PrimaryTextStyle(
          fontWeight: FontWeight.w600,
          fontSize: AppFontSizes.small,
          color: AppColors.textMedium,
        ),
        titleSmall: PrimaryTextStyle(fontWeight: FontWeight.w700, fontSize: AppFontSizes.small),
        headlineSmall: PrimaryTextStyle(fontSize: AppFontSizes.small, fontWeight: FontWeight.w400),
        bodyMedium: PrimaryTextStyle(
          color: AppColors.textMedium,
          fontSize: AppFontSizes.medium,
          fontWeight: FontWeight.w600,
        ),
        displayMedium: PrimaryTextStyle(
          color: AppColors.textMuted,
          fontSize: AppFontSizes.medium,
          fontWeight: FontWeight.w400,
        ),
        labelMedium: PrimaryTextStyle(fontSize: AppFontSizes.medium, fontWeight: FontWeight.w700),
        headlineMedium: PrimaryTextStyle(
          fontSize: AppFontSizes.medium,
          fontWeight: FontWeight.w400,
          color: AppColors.textHint,
        ),
        titleMedium: PrimaryTextStyle(
          color: AppColors.white,
          fontSize: AppFontSizes.medium,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: PrimaryTextStyle(
          fontSize: AppFontSizes.large,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
