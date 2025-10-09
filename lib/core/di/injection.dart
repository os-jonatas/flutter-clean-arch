import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nu_test/core/services/api/service.dart';
import 'package:nu_test/core/services/local/url_local_data_service.dart';
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
  getIt.registerSingleton<Service>(Service(dio: getIt<Dio>()));
  getIt.registerLazySingleton<UrlLocalDataService>(() => UrlLocalDataService());

  getIt.registerSingleton<UrlShortnerRepository>(
    UrlShortnerRepository(
      client: getIt<Service>(),
      localStorage: getIt<UrlLocalDataService>(),
    ),
  );

  getIt.registerFactory<SaveUrlUsecase>(
    () => SaveUrlUsecase(repository: getIt<UrlShortnerRepository>()),
  );
  getIt.registerFactory<GetUrlSavedListUsecase>(
    () => GetUrlSavedListUsecase(getIt<UrlShortnerRepository>()),
  );

  getIt.registerFactory<DropUrlsUsecase>(
    () => DropUrlsUsecase(getIt<UrlShortnerRepository>()),
  );

  getIt.registerFactory<UrlShortnerViewModel>(
    () => UrlShortnerViewModel(
      getUrlSavedListUsecase: getIt<GetUrlSavedListUsecase>(),
      saveUrlUsecase: getIt<SaveUrlUsecase>(),
      dropUrlsUsecase: getIt<DropUrlsUsecase>(),
    ),
  );
}
