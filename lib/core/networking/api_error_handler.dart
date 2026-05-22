import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Maps data-layer exceptions to user-facing messages.
///
/// The class name is kept for compatibility with existing repos. The app now
/// talks to Supabase, so it handles Postgrest / Auth / network errors.
class ApiErrorHandler {
  static String handle(dynamic error) {
    if (error is PostgrestException) {
      return 'Something went wrong while loading data. Please try again.';
    }
    if (error is AuthException) {
      // Supabase auth messages are already user-facing, e.g.
      // "Invalid login credentials", "Email not confirmed".
      return error.message;
    }
    if (error is SocketException) {
      return 'No internet connection.';
    }
    return 'An unexpected error occurred.';
  }
}
