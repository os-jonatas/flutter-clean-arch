import 'package:nu_test/url_shortner/data/storage/url_local_data_source.dart';

class DropUrlsUsecase {
  final UrlLocalDataSource storageService;
  DropUrlsUsecase(this.storageService);
  Future<void> call() async {
    await storageService.clearUrls();
  }
}
