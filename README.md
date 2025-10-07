# 🌐 URL Shortner App

Um projeto Flutter que implementa um encurtador de URLs usando Clean Architecture, RxNotifier para reatividade, GetIt para injeção de dependência e SharedPreferences para armazenamento local.

---

## 📐 Arquitetura

O projeto segue o padrão **Clean Architecture**, que separa o código em camadas independentes, garantindo testabilidade, escalabilidade e manutenção simples.

### Estrutura de diretórios:

```
lib/
├─ core/
│  ├─ api/           → Interfaces e abstrações HTTP (ex: IHttpClient)
│  ├─ services/      → Serviços compartilhados (ex: UrlStorageService)
│  └─ di/            → Setup de injeção de dependência com GetIt
│
├─ url_shortner/
│  ├─ data/          → Camada de dados (repositórios e models)
│  ├─ domain/        → Camada de domínio (entidades e usecases)
│  └─ presentation/  → Camada de apresentação (view e viewmodel)
│
└─ main.dart         → Ponto de entrada da aplicação
```

---

## ⚙️ Camadas em detalhes

### Domain Layer

Camada mais pura, sem dependências de Flutter. Define as regras de negócio e os contratos de uso.

**Exemplo – `get_url_saved_list_usecase.dart`:**

```dart
class GetUrlSavedListUsecase {
  final UrlStorageService storageService;

  GetUrlSavedListUsecase(this.storageService);

  Future<List> call() async {
    final storagelist = await storageService.getUrls();
    return storagelist.map((e) => e.toEntity()).toList();
  }
}
```

---

### Data Layer

Responsável por buscar, salvar e transformar dados vindos de APIs ou do armazenamento local. Aqui vivem os repositórios e models.

**Exemplo – `url_shortner_repository.dart`:**

```dart
class UrlShortnerRepository {
  final IHttpClient client;

  UrlShortnerRepository({required this.client});

  Future shortenUrl(String longUrl) async {
    final response = await client.post('/alias', {'url': longUrl});
    return UrlShortenModel.fromMap({
      'alias': response.data['alias'],
      'originalUrl': response.data['_links']['self'],
      'shortUrl': response.data['_links']['short'],
    });
  }
}
```

---

### Presentation Layer

Contém tudo relacionado à interface do usuário e à reatividade da tela.

**Exemplo – `UrlShortnerViewModel`:**

```dart
class UrlShortnerViewModel {
  final GetUrlSavedListUsecase getUrlSavedListUsecase;
  final SaveUrlUsecase saveUrlUsecase;
  final DropUrlsUsecase dropUrlsUsecase;

  final isLoading = RxNotifier(false);
  final urlList = RxNotifier<List>([]);

  Future fetchSavedUrls() async {
    isLoading.value = true;
    urlList.value = await getUrlSavedListUsecase();
    isLoading.value = false;
  }
}
```

**Exemplo – `UrlShortnerView`:**

```dart
RxBuilder(
  builder: (_) =>
    viewModel.isLoading.value
      ? const CircularProgressIndicator()
      : Expanded(
          child: ListView.separated(
            itemCount: viewModel.urlList.value.length,
            itemBuilder: (context, index) {
              final url = viewModel.urlList.value[index];
              return ListTile(
                title: Text(url.originalUrl),
                subtitle: Text(url.shortUrl),
              );
            },
          ),
        ),
)
```

---

## 🧠 Reatividade com RxNotifier

O RxNotifier é usado para gerenciar estados de forma leve e simples, sem precisar de Streams ou Bloc.

```dart
final RxNotifier isLoading = RxNotifier(false);
```

A UI reage automaticamente via `RxBuilder`:

```dart
RxBuilder(
  builder: (_) => isLoading.value
    ? const CircularProgressIndicator()
    : const Text('Pronto!'),
)
```

---

## 🧩 Injeção de dependência (GetIt)

Toda a configuração é centralizada em `lib/core/di/injection.dart`.

**Exemplo:**

```dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton(() => UrlStorageService());

  // Usecases
  getIt.registerFactory(
    () => GetUrlSavedListUsecase(getIt()),
  );

  // ViewModel
  getIt.registerFactory(() => UrlShortnerViewModel(
    getUrlSavedListUsecase: getIt(),
    saveUrlUsecase: getIt(),
    dropUrlsUsecase: getIt(),
  ));
}
```

---

## 💾 Armazenamento local (SharedPreferences)

A classe `UrlStorageService` é responsável por persistir as URLs encurtadas localmente.

```dart
Future addUrl(UrlShortenModel url) async {
  final prefs = await SharedPreferences.getInstance();
  final current = await getUrls();
  current.add(url);
  final jsonList = jsonEncode(current.map((e) => e.toMap()).toList());
  await prefs.setString(_key, jsonList);
}
```

---

## 🌐 Cliente HTTP (Dio + IHttpClient)

O repositório usa `IHttpClient` para abstrair o Dio e facilitar testes.

```dart
abstract class IHttpClient {
  Future get(String path);
  Future post(String path, Map<String, dynamic> data);
}
```

---

## 🧪 Testes

O projeto possui testes unitários e de UI cobrindo:

- Repositórios (`UrlShortnerRepository`)
- Serviços (`UrlStorageService`)
- ViewModel (`UrlShortnerViewModel`)
- Widgets (`UrlShortnerView`)

**Exemplo:**

```dart
test('fetchSavedUrls deve atualizar lista', () async {
  when(() => mockGetUrls()).thenAnswer((_) async => [UrlEntity(...)]);
  await viewModel.fetchSavedUrls();
  expect(viewModel.urlList.value.isNotEmpty, true);
});
```

---

## ⚙️ Como executar o projeto

1. Clone o repositório:

```bash
git clone https://github.com/seu-repo/url_shortner.git
cd url_shortner
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Execute o projeto:

```bash
flutter run
```