// Validators return null when the value is fine, or an error message when it isn't.
// Keeping them in their own file makes them reusable and easy to test.

String? validateName(String? value) {
  final name = value?.trim() ?? '';
  if (name.isEmpty) return 'Enter a name';
  if (name.length < 2) return 'Name must be at least 2 characters';
  return null;
}

String? validatePhone(String? value) {
  final phone = (value ?? '').replaceAll(' ', '');
  if (phone.isEmpty) return 'Enter a phone number';
  if (!RegExp(r'^[0-9]+$').hasMatch(phone)) return 'Use digits only';
  if (phone.length != 10) return 'Phone number must be 10 digits';
  return null;
}

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Enter an email address';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'Enter a valid email, like name@example.com';
  }
  return null;
}
