import 'package:nu_test/url_shortner/domain/entities/url_entity.dart';

class UrlShortenModel {
  final String originalUrl;
  final String shortUrl;
  final String alias;

  UrlShortenModel({this.originalUrl = '', this.shortUrl = '', this.alias = ''});

  factory UrlShortenModel.fromMap(Map<String, dynamic> map) {
    return UrlShortenModel(
      alias: map['alias'] as String,
      originalUrl: map['originalUrl'] as String,
      shortUrl: map['shortUrl'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {'originalUrl': originalUrl, 'shortUrl': shortUrl, 'alias': alias};
  }

  UrlEntity toEntity() {
    return UrlEntity(
      originalUrl: originalUrl,
      shortUrl: shortUrl,
      alias: alias,
    );
  }
}
