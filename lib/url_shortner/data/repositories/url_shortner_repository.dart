import 'package:nu_test/core/api/i_http_client.dart';
import 'package:nu_test/url_shortner/data/models/url_shorten_model.dart';
import 'package:nu_test/url_shortner/data/storage/url_local_data_source.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';

class UrlShortnerRepository {
  final IHttpClient client;
  final UrlLocalDataSource localStorage;

  UrlShortnerRepository({required this.client, required this.localStorage});

  Future<void> shortenUrl(String longUrl) async {
    try {
      final response = await client.post('/alias', {'url': longUrl});
      final url = UrlShortenModel.fromMap({
        'alias': response.data['alias'],
        'originalUrl': response.data['_links']['self'],
        'shortUrl': response.data['_links']['short'],
      });
      await saveLocalUrl(url);
    } on Exception catch (_) {
      throw Exception();
    }
  }

  Future<String> getOriginalUrl(String alias) async {
    try {
      final response = await client.get('/alias/$alias');
      final url = response.data['url'] as String;
      return url;
    } on Exception catch (_) {
      return '';
    }
  }

  Future<List<UrlEntity>> getStoredUrls() async {
    final storedUrls = await localStorage.getUrls();
    return storedUrls.map((e) => e.toEntity()).toList();
  }

  Future<void> clearStoredUrls() async {
    await localStorage.clearUrls();
  }

  Future<void> saveLocalUrl(UrlShortenModel url) async {
    await localStorage.addUrl(url);
  }
}
