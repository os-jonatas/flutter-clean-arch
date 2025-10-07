import 'package:nu_test/core/services/url_storage_service.dart';
import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';

class SaveUrlUsecase {
  final UrlStorageService storageService;
  final UrlShortnerRepository repository;

  SaveUrlUsecase({required this.storageService, required this.repository});
  Future<bool> call(String url) async {
    try {
      final result = await repository.shortenUrl(url);
      await storageService.addUrl(result);
      return true;
    } on Exception catch (_) {
      rethrow;
    }
  }
}
