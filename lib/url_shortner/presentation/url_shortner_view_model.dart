import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nu_test/core/di/injection.dart';
import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';
import 'package:nu_test/url_shortner/domain/usecases/get_url_saved_list_usecase.dart';
import 'package:nu_test/url_shortner/domain/usecases/save_url_usecase.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'url_shortner.dart';

abstract class UrlShortnerViewModel extends State<UrlShortner> {
  final TextEditingController urlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxNotifier<bool> isLoading = RxNotifier(false);
  final RxNotifier<List<UrlEntity>> urlList = RxNotifier([]);

  final getUrlListUsecase = getIt<GetUrlSavedListUsecase>();
  final saveUrlUsecase = getIt<SaveUrlUsecase>();

  Future<void> fetchSavedUrls() async {
    isLoading.value = true;
    // Simulate a short delay to show loading indicator
    await Future.delayed(const Duration(milliseconds: 500));
    final savedUrls = await getUrlListUsecase();
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
      await fetchSavedUrls();
      urlController.clear();
    }
    isLoading.value = false;
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchSavedUrls();
    });
  }

  @override
  Future<void> dispose() async {
    urlController.dispose();
    isLoading.dispose();
    urlList.dispose();
    super.dispose();
  }

  Future<void> onCopyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('short URL copied to clipboard!')),
    );
  }
}
