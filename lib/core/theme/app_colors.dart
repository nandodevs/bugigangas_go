import 'package:flutter/material.dart';

/// Centralized color tokens for the Bugigangas Go design system.
///
/// Follows a Material 3–inspired palette with a teal primary (#009696).
class AppColors {
  // ── Primary ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF009696);
  static const Color primaryLight = Color(0xFF0B9B9B);
  static const Color primaryDark = Color(0xFF007A7A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFB2F0F0);
  static const Color onPrimaryContainer = Color(0xFF002623);

  // ── Secondary ────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF4D7C8A);
  static const Color secondaryLight = Color(0xFF7EACBA);
  static const Color secondaryDark = Color(0xFF1F4E5C);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ── Tertiary ─────────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF7C5CBF);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFEDE3FF);
  static const Color onTertiaryContainer = Color(0xFF2D1460);

  // ── Surface / Background ─────────────────────────────────────────────
  static const Color background = Color(0xFFF5F7F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color onSurfaceVariant = Color(0xFF757575);
  static const Color surfaceContainerHighest = Color(0xFFE5E7EB);
  static const Color surfaceTint = Color(0xFF009696);

  // ── Outline ──────────────────────────────────────────────────────────
  static const Color outline = Color(0xFFC4C7CC);
  static const Color outlineVariant = Color(0xFFE0E2E6);

  // ── Text ─────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic ─────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Tracking Status (flat, kept for backward compatibility) ──────────
  /// Foreground color for processing / posted status.
  static const Color statusPosted = Color(0xFFE65100);
  /// Foreground color for in-transit status.
  static const Color statusTransit = Color(0xFF0D47A1);
  /// Foreground color for out-for-delivery status.
  static const Color statusOutForDelivery = Color(0xFF4A148C);
  /// Foreground color for delivered status.
  static const Color statusDelivered = Color(0xFF1B5E20);
  /// Foreground color for error / exception status.
  static const Color statusError = Color(0xFFB71C1C);

  // ── Tracking Status Pairs (foreground + background) ──────────────────
  static const StatusColorPair processing = StatusColorPair(
    foreground: Color(0xFFE65100),
    background: Color(0xFFFFF3E0),
  );
  static const StatusColorPair inTransit = StatusColorPair(
    foreground: Color(0xFF0D47A1),
    background: Color(0xFFE3F2FD),
  );
  static const StatusColorPair outForDelivery = StatusColorPair(
    foreground: Color(0xFF4A148C),
    background: Color(0xFFF3E5F5),
  );
  static const StatusColorPair delivered = StatusColorPair(
    foreground: Color(0xFF1B5E20),
    background: Color(0xFFE8F5E9),
  );
  static const StatusColorPair exception = StatusColorPair(
    foreground: Color(0xFFB71C1C),
    background: Color(0xFFFFEBEE),
  );

  // ── Dark Mode ──────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121416);
  static const Color darkSurface = Color(0xFF1A1C1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2E30);
  static const Color darkTextPrimary = Color(0xFFE1E3E6);
  static const Color darkTextSecondary = Color(0xFFB0B3B8);
  static const Color darkTextHint = Color(0xFF7A7C80);
  static const Color darkPrimary = Color(0xFF00B3B3);
  static const Color darkPrimaryContainer = Color(0xFF004D4D);

  // ── Dark Mode Status Pairs ─────────────────────────────────
  static const StatusColorPair processingDark = StatusColorPair(
    foreground: Color(0xFFFFB74D),
    background: Color(0xFF3E2723),
  );
  static const StatusColorPair inTransitDark = StatusColorPair(
    foreground: Color(0xFF64B5F6),
    background: Color(0xFF0D2137),
  );
  static const StatusColorPair outForDeliveryDark = StatusColorPair(
    foreground: Color(0xFFCE93D8),
    background: Color(0xFF2A0D45),
  );
  static const StatusColorPair deliveredDark = StatusColorPair(
    foreground: Color(0xFF81C784),
    background: Color(0xFF1B3D1F),
  );
  static const StatusColorPair exceptionDark = StatusColorPair(
    foreground: Color(0xFFEF9A9A),
    background: Color(0xFF3D1515),
  );
}

/// A pair of foreground and background colors used for status badges.
class StatusColorPair {
  final Color foreground;
  final Color background;

  const StatusColorPair({
    required this.foreground,
    required this.background,
  });
}
