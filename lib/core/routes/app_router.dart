import 'package:go_router/go_router.dart';
import 'package:nu_test/url_shortner/presentation/url_shortner.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const UrlShortner()),
  ],
);
