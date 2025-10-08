import 'package:nu_test/url_shortner/data/storage/url_local_data_source.dart';
import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';

class SaveUrlUsecase {
  final UrlLocalDataSource storageService;
  final UrlShortnerRepository repository;

  SaveUrlUsecase({required this.storageService, required this.repository});
  Future<bool> call(String url) async {
    try {
      final result = await repository.shortenUrl(url);
      await storageService.addUrl(result);
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
