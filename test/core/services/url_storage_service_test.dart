import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nu_test/core/services/url_storage_service.dart';
import 'package:nu_test/url_shortner/data/models/url_shorten_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late UrlStorageService storageService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storageService = UrlStorageService();
  });

  group('UrlStorageService', () {
    test('should return empty list when there is no data saved', () async {
      final urls = await storageService.getUrls();
      expect(urls, isEmpty);
    });

    test('must add and retrieve a saved URL', () async {
      final model = UrlShortenModel(
        alias: 'abc123',
        originalUrl: 'https://flutter.dev',
        shortUrl: 'https://sho.rt/abc123',
      );

      await storageService.addUrl(model);
      final urls = await storageService.getUrls();

      expect(urls.length, 1);
      expect(urls.first.alias, equals('abc123'));
      expect(urls.first.originalUrl, equals('https://flutter.dev'));
      expect(urls.first.shortUrl, equals('https://sho.rt/abc123'));
    });

    test('must accumulate multiple records correctly', () async {
      final urlsToAdd = [
        UrlShortenModel(
          alias: 'a1',
          originalUrl: 'https://flutter.dev',
          shortUrl: 'https://sho.rt/a1',
        ),
        UrlShortenModel(
          alias: 'b2',
          originalUrl: 'https://dart.dev',
          shortUrl: 'https://sho.rt/b2',
        ),
      ];

      for (final u in urlsToAdd) {
        await storageService.addUrl(u);
      }

      final urls = await storageService.getUrls();
      expect(urls.length, 2);
      expect(urls[0].alias, 'a1');
      expect(urls[1].alias, 'b2');
    });

    test('must persist data in JSON format', () async {
      final model = UrlShortenModel(
        alias: 'json1',
        originalUrl: 'https://example.com',
        shortUrl: 'https://sho.rt/json1',
      );

      await storageService.addUrl(model);

      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString('shortened_urls');

      expect(rawJson, isNotNull);
      final decoded = jsonDecode(rawJson!);
      expect(decoded, isA<List>());
      expect(decoded.first['alias'], 'json1');
    });
  });
}
