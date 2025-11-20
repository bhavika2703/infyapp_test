class Validators {
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final pattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!pattern.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.trim().isEmpty) return 'Password is required';
    if (v.trim().length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? notEmpty(String? v, {String label = 'Field'}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }
}
