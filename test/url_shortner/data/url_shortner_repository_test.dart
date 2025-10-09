import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/core/services/api/service.dart';
import 'package:nu_test/url_shortner/data/models/url_shorten_model.dart';
import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';
import 'package:nu_test/core/services/local/url_local_data_service.dart';

class MockUrlLocalDataSource extends Mock implements UrlLocalDataService {}

void main() {
  late Service mockClient;
  late Dio dio;
  late DioAdapter dioAdapter;
  late MockUrlLocalDataSource mockLocalStorage;

  late UrlShortnerRepository repository;

  setUpAll(() {
    registerFallbackValue(UrlShortenModel());
  });

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.short.io'));
    dioAdapter = DioAdapter(dio: dio);
    mockClient = Service(dio: dio);
    mockLocalStorage = MockUrlLocalDataSource();
    repository = UrlShortnerRepository(
      client: mockClient,
      localStorage: mockLocalStorage,
    );
  });

  group('UrlShortnerRepository', () {
    test('must return true when api have success', () async {
      when(
        () => mockLocalStorage.addUrl(any()),
      ).thenAnswer((_) async => Future.value());

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

      await repository.shortenUrl(url);

      verify(() => mockLocalStorage.addUrl(any())).called(1);
    });

    test('must return false when api have error', () async {
      const url = 'https://exemple.dev';

      dioAdapter.onPost(
        '/alias',
        data: {'url': url},
        (server) => server.reply(400, {}),
      );

      expect(() => repository.shortenUrl(url), throwsA(isA<Exception>()));
      verifyNever(() => mockLocalStorage.addUrl(any()));
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
