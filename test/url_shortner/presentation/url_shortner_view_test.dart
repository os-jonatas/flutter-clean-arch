import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nu_test/core/di/injection.dart';
import 'package:nu_test/url_shortner/presentation/url_shortner.dart';

void main() {
  setUpAll(() async {
    await setupInjection();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('UrlShortnerView Widget Tests', () {
    testWidgets('deve renderizar campo de texto e botão', (tester) async {
      await tester.pumpWidget(MaterialApp(home: UrlShortner()));
      await tester.pump();

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    // testWidgets('deve mostrar mensagem de erro ao submeter URL inválida', (
    //   tester,
    // ) async {
    //   await tester.pumpWidget(MaterialApp(home: UrlShortner()));

    //   final field = find.byType(TextFormField);
    //   await tester.enterText(field, 'meusite.com'); // sem http
    //   await tester.tap(find.byIcon(Icons.play_arrow));
    //   await tester.pump();

    //   expect(find.text('Inclua http:// ou https://'), findsOneWidget);
    // });

    // testWidgets('deve exibir indicador de carregamento quando isLoading=true', (
    //   tester,
    // ) async {
    //   await tester.pumpWidget(const MaterialApp(home: UrlShortner()));

    //   // Obtém o estado do widget
    //   final state =
    //       tester.state(find.byType(UrlShortnerView)) as UrlShortnerView;
    //   state.isLoading.value = true;

    //   await tester.pump();

    //   expect(find.byType(CircularProgressIndicator), findsWidgets);
    // });

    // testWidgets('deve exibir mensagem de lista vazia quando não há URLs', (
    //   tester,
    // ) async {
    //   await tester.pumpWidget(const MaterialApp(home: UrlShortner()));

    //   final state =
    //       tester.state(find.byType(UrlShortnerView)) as UrlShortnerView;
    //   state.isLoading.value = false;
    //   state.urlList.value = [];

    //   await tester.pump();

    //   expect(find.text('No URLs shortened yet.'), findsOneWidget);
    // });

    // testWidgets('deve exibir lista de URLs quando houver dados', (
    //   tester,
    // ) async {
    //   await tester.pumpWidget(const MaterialApp(home: UrlShortner()));

    //   final state =
    //       tester.state(find.byType(UrlShortnerView)) as UrlShortnerView;

    //   state.isLoading.value = false;
    //   state.urlList.value = [
    //     UrlEntity(
    //       originalUrl: 'https://flutter.dev',
    //       shortUrl: 'https://sho.rt/a1',
    //     ),
    //     UrlEntity(
    //       originalUrl: 'https://dart.dev',
    //       shortUrl: 'https://sho.rt/b2',
    //     ),
    //   ];

    //   await tester.pumpAndSettle();

    //   expect(find.text('https://flutter.dev'), findsOneWidget);
    //   expect(find.text('https://sho.rt/a1'), findsOneWidget);
    //   expect(find.text('https://dart.dev'), findsOneWidget);
    //   expect(find.text('https://sho.rt/b2'), findsOneWidget);
    // });
  });
}
