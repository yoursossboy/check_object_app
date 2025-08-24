import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RemoteApiService {
  final String rootDirectory = "/";

  final String bucketBaseUrl = "https://storage.yandexcloud.net";
  final String bucketName = "check-object-app";

  final String accessKey = "YCAJEVi7vXmUT2x1oY0QB6v_J";
  final String secretKey = "YOUR_API_KEY_HERE";

  /// **Метод загрузки файла в Yandex Object Storage**
  Future<void> sendDataToS3(
      String filePath, Map<String, dynamic> metadata, String objectId) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception("Файл не найден: $filePath");
    }

    final now = DateTime.now();
    final dateFolder =
        "${now.year}-${_formatNumber(now.month)}-${_formatNumber(now.day)}";
    final objectFolder = "${objectId}_${now.millisecondsSinceEpoch}";

    final destinationFolder = "$dateFolder/$objectFolder";

    await _uploadFileToS3(file, "$destinationFolder/photo.jpg");
    await _uploadJsonToS3(metadata, "$destinationFolder/metadata.json");

    print("Данные и фото успешно загружены в папку: $destinationFolder");
  }

  /// **Метод загрузки фото**
  Future<void> _uploadFileToS3(File file, String destinationPath) async {
    final now = DateTime.now().toUtc();
    final dateTime = _formatDateTime(now);
    final dateStamp = _formatDateStamp(now);

    final canonicalUri = "/$bucketName/$destinationPath";
    final authorizationHeader = _generateV4Signature(
      method: "PUT",
      canonicalUri: canonicalUri,
      dateTime: dateTime,
      dateStamp: dateStamp,
    );

    final uri = Uri.parse("$bucketBaseUrl$canonicalUri");
    final bodyBytes = await file.readAsBytes();
    final headers = {
      "Authorization": authorizationHeader,
      "x-amz-content-sha256": "UNSIGNED-PAYLOAD",
      "x-amz-date": dateTime,
      "Content-Type": "application/octet-stream",
      "Content-length": bodyBytes.length.toString(),
    };

    final request = http.Request("PUT", uri)
      ..headers.addAll(headers)
      ..bodyBytes = await file.readAsBytes();

    print("URI: $uri");
    print("Headers: ${request.headers}");
    print("File length: ${await file.length()}");

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Ошибка загрузки фото: ${response.reasonPhrase}");
    }
  }

  /// **Метод загрузки JSON-файла**
  Future<void> _uploadJsonToS3(
      Map<String, dynamic> jsonData, String destinationPath) async {
    final now = DateTime.now().toUtc();
    final dateTime = _formatDateTime(now);
    final dateStamp = _formatDateStamp(now);

    final canonicalUri = "/$bucketName/$destinationPath";
    final authorizationHeader = _generateV4Signature(
      method: "PUT",
      canonicalUri: canonicalUri,
      dateTime: dateTime,
      dateStamp: dateStamp,
    );

    final uri = Uri.parse("$bucketBaseUrl$canonicalUri");
    final headers = {
      "Authorization": authorizationHeader,
      "x-amz-content-sha256": "UNSIGNED-PAYLOAD",
      "x-amz-date": dateTime,
      "Content-Type": "application/json",
    };

    final request = http.Request("PUT", uri)
      ..headers.addAll(headers)
      ..body = jsonEncode(jsonData);

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Ошибка загрузки метаданных: ${response.reasonPhrase}");
    }
  }

  /// **Формирование подписи AWS Signature V4**
  String _generateV4Signature({
    required String method,
    required String canonicalUri,
    required String dateTime,
    required String dateStamp,
  }) {
    final region = "ru-central1";
    final service = "s3";
    final credentialScope = "$dateStamp/$region/$service/aws4_request";

    final canonicalRequest = [
      method,
      canonicalUri,
      "",
      "host:storage.yandexcloud.net",
      "x-amz-content-sha256:UNSIGNED-PAYLOAD",
      "x-amz-date:$dateTime",
      "",
      "host;x-amz-content-sha256;x-amz-date",
      "UNSIGNED-PAYLOAD"
    ].join("\n");

    final hashedCanonicalRequest =
        sha256.convert(utf8.encode(canonicalRequest)).toString();
    final stringToSign = [
      "AWS4-HMAC-SHA256",
      dateTime,
      credentialScope,
      hashedCanonicalRequest,
    ].join("\n");

    final signingKey = _getSigningKey(secretKey, dateStamp, region, service);
    final signature =
        Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();

    return "AWS4-HMAC-SHA256 Credential=$accessKey/$credentialScope, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=$signature";
  }

  /// **Формирование ключа подписи AWS Signature V4**
  List<int> _getSigningKey(
      String key, String dateStamp, String region, String service) {
    List<int> hmac(List<int> key, String data) =>
        Hmac(sha256, key).convert(utf8.encode(data)).bytes;

    final kDate = hmac(utf8.encode("AWS4$key"), dateStamp);
    final kRegion = hmac(kDate, region);
    final kService = hmac(kRegion, service);
    final kSigning = hmac(kService, "aws4_request");

    return kSigning;
  }

  /// **Форматирование даты и времени**
  String _formatDateTime(DateTime dateTime) =>
      '${dateTime.toIso8601String().replaceAll(RegExp(r'[:-]'), '').split('.')[0]}Z';

  String _formatDateStamp(DateTime dateTime) =>
      dateTime.toIso8601String().split('T')[0].replaceAll('-', '');

  String _formatNumber(int number) => number.toString().padLeft(2, '0');

  /// **Загрузка файла objects.xlsx с сервера через SFTP**
  Future<Uint8List> getData() async {
    final clientSSH = await getClientSSH();
    final sftp = await clientSSH.sftp();

    try {
      await sftp.listdir('upload');
    } on SftpStatusError {}

    final sftpFile = await sftp.open(
      "upload/objects.xlsx",
      mode: SftpFileOpenMode.read,
    );

    final Uint8List byteData = await sftpFile.readBytes();

    clientSSH.close();
    await clientSSH.done;

    return byteData;
  }

  /// **Подключение к серверу SFTP**
  Future<SSHClient> getClientSSH() async {
    final key = await rootBundle.loadString('assets/keys/ftp_temp');
    final privateKey = SSHKeyPair.fromPem(key);

    return SSHClient(
      await SSHSocket.connect('ADRESS', 22),
      username: 'USERNAME',
      identities: privateKey,
    );
  }
}
