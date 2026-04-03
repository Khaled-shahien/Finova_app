import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application color scheme based on Material 3 design tokens
/// Extracted from design assets HTML/Tailwind configuration
class AppColors {
  AppColors._();

  // Primary colors - Deep blue (#24389c)
  static const Color primary = Color(0xFF24389C);
  static const Color primaryContainer = Color(0xFF3F51B5);
  static const Color primaryFixed = Color(0xFFDEE0FF);
  static const Color primaryFixedDim = Color(0xFFBAC3FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFCACFFF);
  static const Color onPrimaryFixed = Color(0xFF00105C);
  static const Color onPrimaryFixedVariant = Color(0xFF293CA0);

  // Secondary colors - Teal (#006a60)
  static const Color secondary = Color(0xFF006A60);
  static const Color secondaryContainer = Color(0xFF85F6E5);
  static const Color secondaryFixed = Color(0xFF85F6E5);
  static const Color secondaryFixedDim = Color(0xFF67D9C9);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF007166);
  static const Color onSecondaryFixed = Color(0xFF00201C);
  static const Color onSecondaryFixedVariant = Color(0xFF005048);

  // Tertiary colors - Brick red (#802000)
  static const Color tertiary = Color(0xFF802000);
  static const Color tertiaryContainer = Color(0xFFA92D00);
  static const Color tertiaryFixed = Color(0xFFFFDBD1);
  static const Color tertiaryFixedDim = Color(0xFFFFB5A0);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFFFC5B5);
  static const Color onTertiaryFixed = Color(0xFF3B0900);
  static const Color onTertiaryFixedVariant = Color(0xFF862200);

  // Error colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Surface colors
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceDim = Color(0xFFD9DADB);
  static const Color surfaceBright = Color(0xFFF8F9FA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainer = Color(0xFFEDEEEF);
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E4);
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF454652);
  static const Color inverseSurface = Color(0xFF2E3132);
  static const Color inverseOnSurface = Color(0xFFF0F1F2);

  // Background and outline
  static const Color background = Color(0xFFF8F9FA);
  static const Color onBackground = Color(0xFF191C1D);
  static const Color outline = Color(0xFF757684);
  static const Color outlineVariant = Color(0xFFC5C5D4);
}

/// Border radius constants extracted from design assets
class AppRadius {
  AppRadius._();

  static const double sm = 4.0; // 0.25rem
  static const double md = 8.0; // 0.5rem
  static const double lg = 12.0;
  static const double xl = 24.0; // 1.5rem
  static const double full = 9999.0;
}

/// Spacing constants for consistent layout
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Custom theme extension for editorial design tokens
class EditorialTheme extends ThemeExtension<EditorialTheme> {
  final Color success;
  final Color warning;
  final Color info;

  const EditorialTheme({
    required this.success,
    required this.warning,
    required this.info,
  });

  @override
  ThemeExtension<EditorialTheme> copyWith({
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return EditorialTheme(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  ThemeExtension<EditorialTheme> lerp(
    ThemeExtension<EditorialTheme>? other,
    double t,
  ) {
    if (other is! EditorialTheme) return this;
    return EditorialTheme(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
    );
  }
}

/// Application theme provider following Material 3 guidelines
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Typography using Google Fonts (Manrope for headlines, Inter for body)
      textTheme: _buildTextTheme(),

      // Component themes
      appBarTheme: _buildAppBarTheme(),
      cardTheme: _buildCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(),
      floatingActionButtonTheme: _buildFABTheme(),
      chipTheme: _buildChipTheme(),

      // Extensions
      extensions: [
        const EditorialTheme(
          success: AppColors.secondary,
          warning: Color(0xFFFFC107),
          info: AppColors.primary,
        ),
      ],

      // Scaffold background
      scaffoldBackgroundColor: AppColors.surface,
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryFixedDim,
      secondary: AppColors.secondaryFixedDim,
      tertiary: AppColors.tertiaryFixedDim,
      surface: const Color(0xFF1A1C1E),
      onSurface: const Color(0xFFE1E3E4),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(brightness: Brightness.dark),
      scaffoldBackgroundColor: const Color(0xFF1A1C1E),
    );
  }

  static TextTheme _buildTextTheme({Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;
    final onSurface = isDark ? const Color(0xFFE1E3E4) : AppColors.onSurface;
    final onSurfaceVariant = isDark
        ? const Color(0xFFC5C5D4)
        : AppColors.onSurfaceVariant;

    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.manrope(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      displayMedium: GoogleFonts.manrope(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      displaySmall: GoogleFonts.manrope(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      headlineLarge: GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16, height: 1.5, color: onSurface),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        height: 1.4,
        color: onSurface,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        height: 1.4,
        color: onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurface,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: onSurfaceVariant,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme() {
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.onSurface,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      ),
    );
  }

  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      color: AppColors.surfaceContainerLowest,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: GoogleFonts.inter(color: AppColors.outline),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme() {
    return BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface.withValues(alpha: 0.8),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey.shade400,
      selectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
    );
  }

  static FloatingActionButtonThemeData _buildFABTheme() {
    return FloatingActionButtonThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }

  static ChipThemeData _buildChipTheme() {
    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}

/// Runtime theme controller used by settings screen.
class AppThemeController extends ChangeNotifier {
  AppThemeController._();

  static final AppThemeController instance = AppThemeController._();

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void setDarkMode(bool enabled) {
    _mode = enabled ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
