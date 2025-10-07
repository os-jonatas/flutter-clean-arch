import 'package:nu_test/core/services/url_storage_service.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';

class GetUrlSavedListUsecase {
  final UrlStorageService storageService;

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
