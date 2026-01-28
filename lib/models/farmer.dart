class Farmer {
  final String id;
  final String name;
  final String phoneNumber;

  Farmer({
    required this.id,
    required String name,
    required String phoneNumber,
  })  : name = _normalizeName(name),
        phoneNumber = normalizePhoneNumber(phoneNumber) {
    _validateName(this.name);
    _validatePhoneNumber(this.phoneNumber);
  }

  // =======================
  // NORMALIZATION
  // =======================

  static String _normalizeName(String name) {
    return name
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase()
        .split(' ')
        .map((part) =>
            part.isNotEmpty ? part[0].toUpperCase() + part.substring(1) : part)
        .join(' ');
  }

  static String normalizePhoneNumber(String phoneNumber) {
    final trimmed = phoneNumber.trim().replaceAll(RegExp(r'\s+'), '');

    // Convert 07XXXXXXXX → +2567XXXXXXXX
    if (trimmed.startsWith('07')) {
      return '+256${trimmed.substring(1)}';
    }

    return trimmed;
  }

  // =======================
  // INTERNAL VALIDATIONS
  // =======================

  static void _validateName(String name) {
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }

    final parts = name.split(' ');

    if (parts.length < 2) {
      throw ArgumentError(
        'Name must contain at least two names (first and last name)',
      );
    }

    for (final part in parts) {
      if (part.length < 3) {
        throw ArgumentError(
          'Each name must have at least 3 characters',
        );
      }

      // Letters only (no digits, no special chars, ASCII-safe)
      if (!RegExp(r'^[A-Za-z]+$').hasMatch(part)) {
        throw ArgumentError(
          'Names must contain only letters (no numbers or special characters)',
        );
      }
    }
  }

  static void _validatePhoneNumber(String phoneNumber) {
    final ugandanPhonePattern = RegExp(r'^(\+2567\d{8})$');

    if (!ugandanPhonePattern.hasMatch(phoneNumber)) {
      throw ArgumentError(
        'Invalid Ugandan phone number. Use +2567XXXXXXXX',
      );
    }
  }

  // =======================
  // FORM VALIDATORS (UI)
  // =======================

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }

    final normalized = _normalizeName(value);
    final parts = normalized.split(' ');

    if (parts.length < 2) {
      return 'Enter at least two names';
    }

    for (final part in parts) {
      if (part.length < 3) {
        return 'Each name must have at least 3 characters';
      }

      if (!RegExp(r'^[A-Za-z]+$').hasMatch(part)) {
        return 'Names must contain only letters';
      }
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number cannot be empty';
    }

    final normalized = normalizePhoneNumber(value);

    final ugandanPhonePattern = RegExp(r'^(\+2567\d{8})$');

    if (!ugandanPhonePattern.hasMatch(normalized)) {
      return 'Invalid phone number. Use +2567XXXXXXXX';
    }

    return null;
  }

  // =======================
  // SERIALIZATION
  // =======================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
