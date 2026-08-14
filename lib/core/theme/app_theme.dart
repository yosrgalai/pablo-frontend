import 'package:flutter/material.dart';

/// Design tokens partagés par toute la plateforme El Bat7a.
/// Basé sur les captures de la plateforme (fond quasi-noir, accent or,
/// touches rouges) + le design system Pablo pour les tokens spécifiques
/// aux cartes (dos de carte, couleurs de score, etc.).
///
/// ⚠️ Le doc "Design System — Pablo" propose un tapis vert (#0B6B4F).
/// Comme Pablo est intégré dans El Bat7a (thème sombre/or), on suit ici
/// le thème de la plateforme pour tout ce qui est "chrome" (fonds, boutons,
/// panneaux) et on garde les tokens du doc uniquement pour les éléments
/// propres aux cartes (dos, face, feedback pair réussie/échouée).
/// À confirmer avec ta binôme si besoin.
class AppColors {
  AppColors._();

  // Fond général (plateforme)
  static const background = Color(0xFF0B0B10);
  static const backgroundGradientEnd = Color(0xFF15111A);
  static const surface = Color(0xFF17161D);
  static const surfaceElevated = Color(0xFF1E1C25);
  static const border = Color(0x33E0B24C); // or à 20% d'opacité

  // Accents plateforme
  static const gold = Color(0xFFE0B24C);
  static const goldBright = Color(0xFFF4C752);
  static const red = Color(0xFFD64545);

  // Texte
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFFB8B8B8);
  static const textDisabled = Color(0xFF6E6E76);

  // Feedback (repris du design system Pablo)
  static const success = Color(0xFF3FA76B);
  static const danger = Color(0xFFD64545);

  // Cartes Pablo (dos / face)
  static const cardBack = Color(0xFF1B1F3B);
  static const cardFace = Color(0xFFFDFDFD);
}

class AppTextStyles {
  AppTextStyles._();

  static const screenTitle = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
  );

  static const sectionLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.1,
  );

  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const bodySecondary = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const scoreValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const buttonLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
}

class AppRadii {
  AppRadii._();
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 20.0;
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.red,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      textTheme: const TextTheme(
        titleLarge: AppTextStyles.screenTitle,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodySecondary,
        labelLarge: AppTextStyles.buttonLabel,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: Colors.black,
          textStyle: AppTextStyles.buttonLabel,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    );
  }
}