import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';

class DropUrlsUsecase {
  final UrlShortnerRepository repository;
  DropUrlsUsecase(this.repository);
  Future<void> call() async {
    await repository.clearStoredUrls();
  }
}
