import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/url_shortner/domain/usecases/drop_urls_usecase.dart';
import 'package:nu_test/url_shortner/domain/usecases/get_url_saved_list_usecase.dart';
import 'package:nu_test/url_shortner/domain/usecases/save_url_usecase.dart';
import 'package:nu_test/url_shortner/presentation/url_shortner_view_model.dart';

class MockGetUrls extends Mock implements GetUrlSavedListUsecase {}

class MockSaveUrl extends Mock implements SaveUrlUsecase {}

class MockDropUrls extends Mock implements DropUrlsUsecase {}

class FakeFormState extends Fake implements FormState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'FakeFormState';
}

void main() {
  late MockGetUrls mockGetUrls;
  late MockSaveUrl mockSaveUrl;
  late MockDropUrls mockDropUrls;
  late UrlShortnerViewModel viewModel;

  setUp(() async {
    mockSaveUrl = MockSaveUrl();
    mockGetUrls = MockGetUrls();
    mockDropUrls = MockDropUrls();

    viewModel = UrlShortnerViewModel(
      getUrlSavedListUsecase: mockGetUrls,
      saveUrlUsecase: mockSaveUrl,
      dropUrlsUsecase: mockDropUrls,
    );
    WidgetsFlutterBinding.ensureInitialized();
  });

  group('UrlShortnerViewModel tests', () {
    test(' when fetchSavedUrls is called, getUrlsUsecase must be called', () {
      when(() => mockGetUrls()).thenAnswer((_) async => []);

      viewModel.fetchSavedUrls();
      expect(viewModel.isLoading.value, true);

      verify(() => mockGetUrls()).called(1);
    });

    test('when saveUrl is called, saveUrlUsecase must be called', () async {
      when(() => mockSaveUrl.call(any())).thenAnswer((_) async => true);
      when(() => mockGetUrls()).thenAnswer((_) async => []);

      viewModel.urlController.text = 'https://flutter.dev';
      await viewModel.saveUrl();

      expect(viewModel.isLoading.value, false);
      verify(() => mockSaveUrl.call('https://flutter.dev')).called(1);
      verify(() => mockGetUrls()).called(1);
    });

    test('when saveUrl failure, getUrlUsecase dont must be called', () async {
      when(() => mockSaveUrl.call(any())).thenAnswer((_) async => false);

      viewModel.urlController.text = 'https://flutter.dev';
      await viewModel.saveUrl();

      expect(viewModel.isLoading.value, false);
      verify(() => mockSaveUrl.call('https://flutter.dev')).called(1);
      verifyNever(() => mockGetUrls());
    });

    test('when dispose is called, fields must be empty', () async {
      await viewModel.dispose();

      expect(
        () => viewModel.isLoading.value = true,
        throwsA(isA<FlutterError>()),
      );
      expect(() => viewModel.urlList.value = [], throwsA(isA<FlutterError>()));
      expect(viewModel.urlController.text, '');
    });

    test('when dropUrls is called, dropUrlsUsecase must be called', () async {
      when(() => mockDropUrls()).thenAnswer((_) async {});
      when(() => mockGetUrls()).thenAnswer((_) async => []);
      await viewModel.dropUrls();

      expect(viewModel.urlList.value, isEmpty);
      verify(() => mockDropUrls()).called(1);
    });
  });
}
