import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password, String salt) {
  final codec = utf8;
  final key = utf8.encode(salt);

  final hmac = Hmac(sha256, key);
  final digest = hmac.convert(codec.encode(password));

  return digest.toString();
}
