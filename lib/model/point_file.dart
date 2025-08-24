import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class PointFile {
  String type;
  String fileName;
  String path;
  PlatformFile? file;

  PointFile({
    required this.type,
    required this.fileName,
    required this.path,
    this.file,
  });

  readFile() async {
    if (path != "") {
      final file = File(path);
      if (file.existsSync()) {
        this.file = PlatformFile(
            name: fileName,
            size: file.lengthSync(),
            bytes: file.readAsBytesSync());
      }
    } else {
      print("Нет данных о файле");
    }
  }

  factory PointFile.fromFile(PlatformFile file, String type) {
    return PointFile(
        fileName: file.name,
        type: type,
        file: file,
        path: kIsWeb ? "" : file.path ?? "");
  }

  void setFile(PlatformFile file, String type) {
    this.file = file;
    fileName = file.name;
    this.type = type;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'fileName': fileName,
      'path': path,
    };
  }

  factory PointFile.fromMap(Map<String, dynamic> map) {
    return PointFile(
      type: map['type'] as String,
      fileName: map['fileName'] as String,
      path: map['path'] as String,
    )..readFile();
  }

  String toJson() => json.encode(toMap());

  factory PointFile.fromJson(String source) =>
      PointFile.fromMap(json.decode(source) as Map<String, dynamic>);
}