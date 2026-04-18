import 'dart:convert';

import 'package:news_check_app/models/models.dart';

class TokenUtils {
  static TokenModel? parseTokenModel(String token) {
    final tokenSplits = token.split(".");
    if (tokenSplits.length != 3) {
      return null;
    }
    String payload = tokenSplits[1];
    int mod = payload.length % 4;
      if (mod > 0) {
        payload += "=" * (4 - mod);
      }
    final payloadMap = jsonDecode(utf8.decode(base64Decode(payload)));
    final tokenModel = TokenModel.fromJson(payloadMap);
    return tokenModel;
  }
}