import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/url_shortner/data/storage/url_local_data_source.dart';
import 'package:nu_test/url_shortner/data/models/url_shorten_model.dart';
import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';
import 'package:nu_test/url_shortner/domain/usecases/save_url_usecase.dart';

class MockUrlStorageService extends Mock implements UrlLocalDataSource {}

class MockUrlShortnerRepository extends Mock implements UrlShortnerRepository {}

void main() {
  late MockUrlStorageService mockStorage;
  late SaveUrlUsecase usecase;
  late MockUrlShortnerRepository mockRepository;

  setUpAll(() {
    mockStorage = MockUrlStorageService();
    mockRepository = MockUrlShortnerRepository();
    usecase = SaveUrlUsecase(
      storageService: mockStorage,
      repository: mockRepository,
    );

    registerFallbackValue(
      UrlShortenModel(
        alias: 'abc123',
        originalUrl: 'https://flutter.dev',
        shortUrl: 'https://sho.rt/abc123',
      ),
    );
  });

  group('SaveUrlUsecase', () {
    final testModel = UrlShortenModel(
      alias: 'abc123',
      originalUrl: 'https://flutter.dev',
      shortUrl: 'https://sho.rt/abc123',
    );
    test('must call addUrl of storageService with correct model', () async {
      when(() => mockStorage.addUrl(any())).thenAnswer((_) async => {});
      when(
        () => mockRepository.shortenUrl(any()),
      ).thenAnswer((_) async => testModel);

      await usecase('https://flutter.dev');

      verify(() => mockStorage.addUrl(testModel)).called(1);
      verifyNoMoreInteractions(mockStorage);
    });

    test('should return false when repository throws exception', () async {
      when(
        () => mockStorage.addUrl(any()),
      ).thenThrow(Exception('Erro ao salvar'));
      when(
        () => mockRepository.shortenUrl(any()),
      ).thenAnswer((_) async => testModel);

      final result = await usecase('https://flutter.dev');

      expect(result, isFalse);
    });
  });
}
