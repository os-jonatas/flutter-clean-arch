import 'dart:convert';

import 'package:nu_test/url_shortner/data/models/url_shorten_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UrlStorageService {
  static const _key = 'shortened_urls';

  Future<void> addUrl(UrlShortenModel url) async {
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
}
