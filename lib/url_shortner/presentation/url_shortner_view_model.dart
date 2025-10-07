// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';
import 'package:nu_test/url_shortner/domain/usecases/get_url_saved_list_usecase.dart';
import 'package:nu_test/url_shortner/domain/usecases/save_url_usecase.dart';

class UrlShortnerViewModel {
  final GetUrlSavedListUsecase getUrlSavedListUsecase;
  final SaveUrlUsecase saveUrlUsecase;

  UrlShortnerViewModel({
    required this.getUrlSavedListUsecase,
    required this.saveUrlUsecase,
  });

  final TextEditingController urlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxNotifier<bool> isLoading = RxNotifier(false);
  final RxNotifier<List<UrlEntity>> urlList = RxNotifier([]);

  Future<void> fetchSavedUrls() async {
    isLoading.value = true;
    final savedUrls = await getUrlSavedListUsecase();
    urlList.value = savedUrls;
    isLoading.value = false;
  }

  Future<void> saveUrl() async {
    isLoading.value = true;
    final url = urlController.text.trim();
    if (!formKey.currentState!.validate()) {
      isLoading.value = false;
      return;
    }
    final success = await saveUrlUsecase.call(url);
    if (success) {
      urlController.clear();
      await fetchSavedUrls();
    }
    isLoading.value = false;
  }

  Future<void> dispose() async {
    urlController.dispose();
    isLoading.dispose();
    urlList.dispose();
  }
}
