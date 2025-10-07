import 'package:nu_test/core/services/url_storage_service.dart';

class DropUrlsUsecase {
  final UrlStorageService storageService;
  DropUrlsUsecase(this.storageService);
  Future<void> call() async {
    await storageService.clearUrls();
  }
}
