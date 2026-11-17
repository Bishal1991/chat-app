import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Email validator regex check', () {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    expect(emailRegex.hasMatch('test@gmail.com'), isTrue);
    expect(emailRegex.hasMatch('user.name@domain.co'), isTrue);
    expect(emailRegex.hasMatch('invalid-email'), isFalse);
    expect(emailRegex.hasMatch('test@'), isFalse);
    expect(emailRegex.hasMatch('@domain.com'), isFalse);
  });
}
