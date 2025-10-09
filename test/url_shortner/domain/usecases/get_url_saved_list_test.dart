import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';
import 'package:nu_test/url_shortner/domain/usecases/get_url_saved_list_usecase.dart';

class MockUrlRepository extends Mock implements UrlShortnerRepository {}

void main() {
  late GetUrlSavedListUsecase usecase;
  late MockUrlRepository repository;

  setUp(() {
    repository = MockUrlRepository();
    usecase = GetUrlSavedListUsecase(repository);
  });

  group('GetUrlSavedList UseCase', () {
    test(
      'should return the list of URLs when storageService.getUrls() succeeds',
      () async {
        final urls = [
          UrlEntity(
            alias: 'abc123',
            originalUrl: 'https://flutter.dev',
            shortUrl: 'https://sho.rt/abc123',
          ),
          UrlEntity(
            alias: 'xyz789',
            originalUrl: 'https://dart.dev',
            shortUrl: 'https://sho.rt/xyz789',
          ),
        ];

        when(() => repository.getStoredUrls()).thenAnswer((_) async => urls);

        final result = await usecase();
        expect(result, isA<List<UrlEntity>>());
        expect(result.length, 2);
        verify(() => repository.getStoredUrls()).called(1);
      },
    );

    test(
      'should return empty list when storageService throws exception',
      () async {
        when(
          () => repository.getStoredUrls(),
        ).thenThrow(Exception('Erro ao acessar storage'));

        final result = await usecase();

        expect(result, isEmpty);
        verify(() => repository.getStoredUrls()).called(1);
      },
    );
  });
}
