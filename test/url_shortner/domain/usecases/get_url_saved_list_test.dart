import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/core/services/url_storage_service.dart';
import 'package:nu_test/url_shortner/data/models/url_shorten_model.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';
import 'package:nu_test/url_shortner/domain/usecases/get_url_saved_list_usecase.dart';

class MockUrlStorageService extends Mock implements UrlStorageService {}

void main() {
  late GetUrlSavedListUsecase usecase;
  late MockUrlStorageService mockStorage;

  setUp(() {
    mockStorage = MockUrlStorageService();
    usecase = GetUrlSavedListUsecase(mockStorage);
  });

  group('GetUrlSavedList UseCase', () {
    test(
      'should return the list of URLs when storageService.getUrls() succeeds',
      () async {
        final urls = [
          UrlShortenModel(
            alias: 'abc123',
            originalUrl: 'https://flutter.dev',
            shortUrl: 'https://sho.rt/abc123',
          ),
          UrlShortenModel(
            alias: 'xyz789',
            originalUrl: 'https://dart.dev',
            shortUrl: 'https://sho.rt/xyz789',
          ),
        ];

        when(() => mockStorage.getUrls()).thenAnswer((_) async => urls);

        final result = await usecase();
        expect(result, isA<List<UrlEntity>>());
        expect(result.length, 2);
        verify(() => mockStorage.getUrls()).called(1);
      },
    );

    test(
      'should return empty list when storageService throws exception',
      () async {
        when(
          () => mockStorage.getUrls(),
        ).thenThrow(Exception('Erro ao acessar storage'));

        final result = await usecase();

        expect(result, isEmpty);
        verify(() => mockStorage.getUrls()).called(1);
      },
    );
  });
}
