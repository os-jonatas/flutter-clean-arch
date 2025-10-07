import 'package:nu_test/core/api/i_http_client.dart';
import 'package:nu_test/url_shortner/data/models/url_shorten_model.dart';

class UrlShortnerRepository {
  final IHttpClient client;

  UrlShortnerRepository({required this.client});

  Future<UrlShortenModel> shortenUrl(String longUrl) async {
    try {
      final response = await client.post('/alias', {'url': longUrl});
      final url = UrlShortenModel.fromMap({
        'alias': response.data['alias'],
        'originalUrl': response.data['_links']['self'],
        'shortUrl': response.data['_links']['short'],
      });
      return url;
    } on Exception catch (_) {
      return UrlShortenModel();
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
}
