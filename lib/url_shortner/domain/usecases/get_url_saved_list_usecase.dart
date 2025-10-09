import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';

class GetUrlSavedListUsecase {
  final UrlShortnerRepository repository;

  GetUrlSavedListUsecase(this.repository);

  Future<List<UrlEntity>> call() async {
    try {
      final storagelist = await repository.getStoredUrls();
      return storagelist;
    } on Exception catch (_) {
      return [];
    }
  }
}
