class AuthException implements Exception {
  static Map<String, String> exceptions = {
    'email-already-in-use': 'This email already exists',
    'invalid-email': 'This email is invalid',
    'operation-not-allowed': 'Connection with server failed',
    'weak-password': 'Can not use a weak password',
    'user-disabled': 'This account is suspended',
    'user-not-found': 'This account does not exists',
    'wrong-password': 'The password is wrong',
    'invalid-credential': 'Authentication credentials are incorrect',
  };

  final String code;

  AuthException({required this.code});

  @override
  String toString() {
    return exceptions[code] ?? 'Authentication failed';
  }
}