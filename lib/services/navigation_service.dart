import 'package:flutter/material.dart';

/// Centralized navigation service for consistent navigation patterns
class NavigationService {
  /// Navigate to new screen
  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Replace current screen
  static Future<T?> pushReplacement<T>(BuildContext context, Widget screen) {
    return Navigator.pushReplacement<T, void>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Clear stack and navigate to new screen
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget screen, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
      predicate ?? (route) => false,
    );
  }

  /// Go back to previous screen
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  /// Check if can go back
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Pop until specific route
  static void popUntil(BuildContext context, bool Function(Route<dynamic>) predicate) {
    Navigator.popUntil(context, predicate);
  }

  /// Navigate to home screen (clear stack)
  static Future<T?> navigateToHome<T>(BuildContext context, Widget homeScreen) {
    return pushAndRemoveUntil<T>(context, homeScreen);
  }
}
