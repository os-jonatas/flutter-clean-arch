import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nu_test/url_shortner/data/models/url_shorten_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UrlLocalDataService {
  static const _key = 'shortened_urls';

  Future<void> addUrl(UrlShortenModel url) async {
    if (url.originalUrl.isEmpty || url.shortUrl.isEmpty) {
      debugPrint('Erro ao salvar URL localmente: URL vazia');
      throw Exception('Invalid URL');
    }
    final prefs = await SharedPreferences.getInstance();
    final currentUrls = await getUrls();
    currentUrls.add(url);
    final jsonList = jsonEncode(currentUrls.map((e) => e.toMap()).toList());
    await prefs.setString(_key, jsonList);
  }

  Future<List<UrlShortenModel>> getUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final decoded = jsonDecode(jsonString) as List;
    return decoded
        .map((e) => UrlShortenModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> clearUrls() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
