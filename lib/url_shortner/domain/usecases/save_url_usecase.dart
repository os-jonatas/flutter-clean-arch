import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';

class SaveUrlUsecase {
  final UrlShortnerRepository repository;

  SaveUrlUsecase({required this.repository});
  Future<bool> call(String url) async {
    try {
      await repository.shortenUrl(url);
      await repository.getStoredUrls();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
