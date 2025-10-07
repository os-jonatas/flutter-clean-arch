import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nu_test/core/api/client.dart';
import 'package:nu_test/core/services/url_storage_service.dart';
import 'package:nu_test/url_shortner/data/repositories/url_shortner_repository.dart';
import 'package:nu_test/url_shortner/domain/usecases/drop_urls_usecase.dart';
import 'package:nu_test/url_shortner/domain/usecases/get_url_saved_list_usecase.dart';
import 'package:nu_test/url_shortner/domain/usecases/save_url_usecase.dart';
import 'package:nu_test/url_shortner/presentation/url_shortner_view_model.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  getIt.registerLazySingleton<Dio>(() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://url-shortener-server.onrender.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  });
  getIt.registerSingleton<Client>(Client(dio: getIt<Dio>()));
  getIt.registerSingleton<UrlShortnerRepository>(
    UrlShortnerRepository(client: getIt<Client>()),
  );
  getIt.registerLazySingleton<UrlStorageService>(() => UrlStorageService());

  getIt.registerFactory<SaveUrlUsecase>(
    () => SaveUrlUsecase(
      storageService: getIt<UrlStorageService>(),
      repository: getIt<UrlShortnerRepository>(),
    ),
  );
  getIt.registerFactory<GetUrlSavedListUsecase>(
    () => GetUrlSavedListUsecase(getIt<UrlStorageService>()),
  );

  getIt.registerFactory<DropUrlsUsecase>(
    () => DropUrlsUsecase(getIt<UrlStorageService>()),
  );

  getIt.registerFactory<UrlShortnerViewModel>(
    () => UrlShortnerViewModel(
      getUrlSavedListUsecase: getIt<GetUrlSavedListUsecase>(),
      saveUrlUsecase: getIt<SaveUrlUsecase>(),
      dropUrlsUsecase: getIt<DropUrlsUsecase>(),
    ),
  );
}
