import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/url_shortner/data/models/url_shorten_model.dart';
import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';
import 'package:nu_test/url_shortner/domain/usecases/save_url_usecase.dart';

class MockUrlShortnerRepository extends Mock implements UrlShortnerRepository {}

void main() {
  late SaveUrlUsecase usecase;
  late MockUrlShortnerRepository mockRepository;

  setUpAll(() {
    mockRepository = MockUrlShortnerRepository();
    usecase = SaveUrlUsecase(repository: mockRepository);

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
    test('should call addUrl of storageService with correct model', () async {
      when(
        () => mockRepository.shortenUrl(any()),
      ).thenAnswer((_) async => testModel);

      when(() => mockRepository.getStoredUrls()).thenAnswer((_) async => []);

      final result = await usecase('https://flutter.dev');

      expect(result, isTrue);
      verify(() => mockRepository.shortenUrl('https://flutter.dev')).called(1);
      verify(() => mockRepository.getStoredUrls()).called(1);
    });

    test('should return false when repository throws exception', () async {
      when(
        () => mockRepository.shortenUrl(any()),
      ).thenAnswer((_) async => throw Exception('Erro ao acessar API'));

      final result = await usecase('https://flutter.dev');

      expect(result, isFalse);
    });
  });
}
