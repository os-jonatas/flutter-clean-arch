import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nu_test/core/di/injection.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'url_shortner_view_model.dart';

class UrlShortnerView extends StatefulWidget {
  final UrlShortnerViewModel? injectedViewModel;
  const UrlShortnerView({super.key, this.injectedViewModel});

  @override
  State<UrlShortnerView> createState() => _UrlShortnerViewState();
}

class _UrlShortnerViewState extends State<UrlShortnerView> {
  late final UrlShortnerViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.injectedViewModel ?? getIt<UrlShortnerViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchSavedUrls();
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> onCopyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('short URL copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: viewModel.formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: viewModel.urlController,
                        decoration: const InputDecoration(
                          hintText: 'https://exemplo.com/minha-pagina',
                          labelText: 'URL',
                          prefixIcon: Icon(Icons.link),
                        ),
                        validator: (value) {
                          final text = (value ?? '').trim();
                          if (text.isEmpty) return 'Informe uma URL';
                          final hasScheme =
                              text.startsWith('http://') ||
                              text.startsWith('https://');
                          if (!hasScheme) return 'Inclua http:// ou https://';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    RxBuilder(
                      builder:
                          (_) =>
                              viewModel.isLoading.value
                                  ? const Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: IconButton(
                                      onPressed: viewModel.saveUrl,
                                      icon: Icon(Icons.play_arrow, size: 32),
                                    ),
                                  ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Text(
                  'Recently Shortened URLs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                RxBuilder(
                  builder:
                      (_) =>
                          viewModel.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : viewModel.urlList.value.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: const Text('No URLs shortened yet.'),
                              )
                              : Expanded(
                                child: ListView.separated(
                                  itemCount: viewModel.urlList.value.length,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (context, index) {
                                    final urlEntity =
                                        viewModel.urlList.value[index];
                                    return ListTile(
                                      title: Text(
                                        urlEntity.originalUrl,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(urlEntity.shortUrl),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.copy),
                                        onPressed: () {
                                          onCopyToClipboard(urlEntity.shortUrl);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
