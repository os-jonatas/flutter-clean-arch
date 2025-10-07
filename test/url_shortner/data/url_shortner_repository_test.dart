import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:nu_test/core/api/client.dart';
import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';

void main() {
  late Client mockClient;
  late Dio dio;
  late DioAdapter dioAdapter;

  late UrlShortnerRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.short.io'));
    dioAdapter = DioAdapter(dio: dio);
    mockClient = Client(dio: dio);
    repository = UrlShortnerRepository(client: mockClient);
  });

  group('UrlShortnerRepository', () {
    test('must return true when api have success', () async {
      const url = 'https://exemple.dev';
      const fakeResponse = {
        "alias": "1110289033",
        "_links": {
          "self": "https://exemple.dev",
          "short": "https://sho.rt/e.dev",
        },
      };

      dioAdapter.onPost(
        '/alias',
        data: {'url': url},
        (server) => server.reply(201, fakeResponse),
      );

      final result = await repository.shortenUrl(url);

      expect(result.originalUrl, equals('https://exemple.dev'));
      expect(result.shortUrl, equals('https://sho.rt/e.dev'));
      expect(result.alias, equals('1110289033'));
    });

    test('must return false when api have error', () async {
      const url = 'https://exemple.dev';

      dioAdapter.onPost(
        '/alias',
        data: {'url': url},
        (server) => server.reply(400, {}),
      );

      final result = await repository.shortenUrl(url);

      expect(result.originalUrl, isEmpty);
      expect(result.shortUrl, isEmpty);
    });

    test('must return original url when api have success', () async {
      const alias = '1110289033';
      const fakeResponse = {"url": "https://exemple.dev"};

      dioAdapter.onGet(
        '/alias/$alias',
        (server) => server.reply(200, fakeResponse),
      );

      final result = await repository.getOriginalUrl(alias);

      expect(result, equals('https://exemple.dev'));
    });

    test('must return empty string when api have error', () async {
      const alias = '1110289033';

      dioAdapter.onGet('/alias/$alias', (server) => server.reply(400, {}));

      final result = await repository.getOriginalUrl(alias);

      expect(result, isEmpty);
    });
  });
}
