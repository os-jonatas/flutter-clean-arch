import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';
import 'package:nu_test/url_shortner/domain/usecases/drop_urls_usecase.dart';

class MockUrlRepository extends Mock implements UrlShortnerRepository {}

void main() {
  late DropUrlsUsecase usecase;
  late MockUrlRepository repository;

  setUp(() {
    repository = MockUrlRepository();
    usecase = DropUrlsUsecase(repository);
  });

  group('DropUrlsUsecase test', () {
    test('should call storageService.clearUrls()', () async {
      when(() => repository.clearStoredUrls()).thenAnswer((_) async {});

      await usecase();

      verify(() => repository.clearStoredUrls()).called(1);
    });
  });
}
