import 'package:nu_test/url_shortner/data/storage/url_local_data_source.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';

class GetUrlSavedListUsecase {
  final UrlLocalDataSource storageService;

  GetUrlSavedListUsecase(this.storageService);

  Future<List<UrlEntity>> call() async {
    try {
      final storagelist = await storageService.getUrls();
      final fetchedList = storagelist.map((e) => e.toEntity()).toList();
      return fetchedList;
    } on Exception catch (_) {
      return [];
    }
  }
}
