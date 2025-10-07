import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/core/services/url_storage_service.dart';
import 'package:nu_test/url_shortner/domain/usecases/drop_urls_usecase.dart';

class MockUrlStorageService extends Mock implements UrlStorageService {}

void main() {
  late DropUrlsUsecase usecase;
  late MockUrlStorageService mockStorage;

  setUp(() {
    mockStorage = MockUrlStorageService();
    usecase = DropUrlsUsecase(mockStorage);
  });

  group('DropUrlsUsecase test', () {
    test('should call storageService.clearUrls()', () async {
      when(() => mockStorage.clearUrls()).thenAnswer((_) async {});

      await usecase();

      verify(() => mockStorage.clearUrls()).called(1);
    });
  });
}
