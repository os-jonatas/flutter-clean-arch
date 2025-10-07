import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';
import 'package:nu_test/url_shortner/domain/usecases/get_url_saved_list_usecase.dart';
import 'package:nu_test/url_shortner/domain/usecases/save_url_usecase.dart';
import 'package:nu_test/url_shortner/presentation/url_shortner_view.dart';
import 'package:nu_test/url_shortner/presentation/url_shortner_view_model.dart';

class MockGetUrls extends Mock implements GetUrlSavedListUsecase {}

class MockSaveUrl extends Mock implements SaveUrlUsecase {}

void main() {
  late GetIt getIt;
  late UrlShortnerViewModel mockViewModel;

  setUp(() async {
    getIt = GetIt.instance;
    await getIt.reset();
    final mockGetUrls = MockGetUrls();
    final mockSaveUrl = MockSaveUrl();

    when(() => mockGetUrls()).thenAnswer((_) async => []);
    when(() => mockSaveUrl.call(any())).thenAnswer((_) async => true);

    mockViewModel = UrlShortnerViewModel(
      getUrlSavedListUsecase: mockGetUrls,
      saveUrlUsecase: mockSaveUrl,
    );
    getIt.registerSingleton<UrlShortnerViewModel>(mockViewModel);
  });

  tearDown(() async => await getIt.reset());

  group('UrlShortnerView UI Tests', () {
    testWidgets('should render text field, button and title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.text('Recently Shortened URLs'), findsOneWidget);
    });

    testWidgets('should show CircularProgressIndicator when isLoading = true', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      mockViewModel.isLoading.value = true;
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
      'should display "No URLs shortened yet." message when list is empty',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

        mockViewModel.isLoading.value = false;
        mockViewModel.urlList.value = [];
        await tester.pump();

        expect(find.text('No URLs shortened yet.'), findsOneWidget);
      },
    );

    testWidgets('should display list of URLs when urlList has items', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      mockViewModel.isLoading.value = false;
      mockViewModel.urlList.value = [
        UrlEntity(
          originalUrl: 'https://flutter.dev',
          shortUrl: 'https://sho.rt/a1',
          alias: 'a1',
        ),
        UrlEntity(
          originalUrl: 'https://dart.dev',
          shortUrl: 'https://sho.rt/b2',
          alias: 'b2',
        ),
      ];
      await tester.pump();

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('https://flutter.dev'), findsOneWidget);
      expect(find.text('https://dart.dev'), findsOneWidget);
    });

    testWidgets('must validate invalid URL in text field', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      await tester.enterText(find.byType(TextFormField), 'meusite.com');
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();

      expect(find.text('Inclua http:// ou https://'), findsOneWidget);
    });
  });
}
