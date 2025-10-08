import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/url_shortner/data/storage/url_local_data_source.dart';
import 'package:nu_test/url_shortner/domain/usecases/drop_urls_usecase.dart';

class MockUrlStorageService extends Mock implements UrlLocalDataSource {}

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
