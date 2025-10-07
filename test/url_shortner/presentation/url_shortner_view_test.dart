import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';
import 'package:nu_test/url_shortner/domain/usecases/drop_urls_usecase.dart';
import 'package:nu_test/url_shortner/domain/usecases/get_url_saved_list_usecase.dart';
import 'package:nu_test/url_shortner/domain/usecases/save_url_usecase.dart';
import 'package:nu_test/url_shortner/presentation/url_shortner_view.dart';
import 'package:nu_test/url_shortner/presentation/url_shortner_view_model.dart';

class MockGetUrls extends Mock implements GetUrlSavedListUsecase {}

class MockSaveUrl extends Mock implements SaveUrlUsecase {}

class MockDropUrls extends Mock implements DropUrlsUsecase {}

void main() {
  late GetIt getIt;
  late UrlShortnerViewModel viewModel;
  late MockDropUrls mockDropUrls;
  late MockGetUrls mockGetUrls;
  late MockSaveUrl mockSaveUrl;

  setUp(() async {
    getIt = GetIt.instance;
    await getIt.reset();
    mockGetUrls = MockGetUrls();
    mockSaveUrl = MockSaveUrl();
    mockDropUrls = MockDropUrls();

    when(() => mockGetUrls()).thenAnswer((_) async => []);
    when(() => mockSaveUrl.call(any())).thenAnswer((_) async => true);
    when(() => mockDropUrls()).thenAnswer((_) async => {});

    viewModel = UrlShortnerViewModel(
      getUrlSavedListUsecase: mockGetUrls,
      saveUrlUsecase: mockSaveUrl,
      dropUrlsUsecase: mockDropUrls,
    );
    getIt.registerSingleton<UrlShortnerViewModel>(viewModel);
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

      viewModel.isLoading.value = true;
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
      'should display "No URLs shortened yet." message when list is empty',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

        viewModel.isLoading.value = false;
        viewModel.urlList.value = [];
        await tester.pump();

        expect(find.text('No URLs shortened yet.'), findsOneWidget);
      },
    );

    testWidgets('should display list of URLs when urlList has items', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      viewModel.isLoading.value = false;
      viewModel.urlList.value = [
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

    testWidgets('should display delete icon if urls list is not empty', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      viewModel.isLoading.value = false;
      viewModel.urlList.value = [
        UrlEntity(
          originalUrl: 'https://flutter.dev',
          shortUrl: 'https://sho.rt/a1',
          alias: 'a1',
        ),
      ];
      await tester.pump();

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('should not display delete icon if urls list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      viewModel.isLoading.value = false;
      viewModel.urlList.value = [];
      await tester.pump();

      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('should call dropUrls when delete icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      viewModel.isLoading.value = false;
      viewModel.urlList.value = [
        UrlEntity(
          originalUrl: 'https://flutter.dev',
          shortUrl: 'https://sho.rt/a1',
          alias: 'a1',
        ),
      ];
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      verify(() => mockDropUrls.call()).called(1);
    });

    testWidgets('shoudl display AlertDiolog when delete icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      viewModel.isLoading.value = false;
      viewModel.urlList.value = [
        UrlEntity(
          originalUrl: 'https://flutter.dev',
          shortUrl: 'https://sho.rt/a1',
          alias: 'a1',
        ),
      ];
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Confirm deletion'), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete all saved URLs?'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    });

    testWidgets('should render error message when save url returns false', (
      tester,
    ) async {
      when(
        () => mockSaveUrl.call('https://flutter.dev'),
      ).thenAnswer((_) async => false);

      await tester.pumpWidget(const MaterialApp(home: UrlShortnerView()));

      await tester.enterText(find.byType(TextFormField), 'https://flutter.dev');
      await tester.tap(find.byIcon(Icons.play_arrow));

      await tester.pumpAndSettle();

      expect(
        find.text('Failed to shorten URL. Please try again.'),
        findsOneWidget,
      );
    });
  });
}
