import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:check_object/core/constants.dart';
import 'package:check_object/model/selected_item.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class LocalApiService {
  Future fromFile(FileTypeApi fileType) async {
    late final String filename;
    switch (fileType) {
      case FileTypeApi.json:
        filename = Utility.jsonFileName;
      case FileTypeApi.xlsx:
        filename = Utility.excelFileName;
    }
    try {

      switch (fileType) {
        case FileTypeApi.json:
          final file = await localFileData(filename);
          final result = await file.readAsString();
          return SelectedItems
              .fromJson(json.decode(result))
              .selectedItems;
        case FileTypeApi.xlsx:
          if(await checkExist(filename)){
            final file = await localFileData(filename);
            final Uint8List result = await file.readAsBytes();
            return Excel.decodeBytes(result);
          }
          return '';
      }
    } catch (e) {
      return <SelectedItem>[];
    }
  }

  Future<void> toFile({required dynamic data}) async {
    late final String filename;
    filename = Utility.jsonFileName;
    final file = await localFileData(filename);
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> saveFile({required Uint8List byteData}) async {
    late final String filename;
    filename = Utility.excelFileName;
    final file = await localFileData(filename);
   file
      ..createSync(recursive: true)
      ..writeAsBytesSync(byteData);
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> localFileData(String filename) async {
    final dir = await _localPath;
    final filePath = '$dir/$filename';
    if (!await Directory(File(filePath).parent.path).exists()) {
      await Directory(File(filePath).parent.path).create();
    }
    if (File(filePath).existsSync()) {
      return File(filePath);
    } else {
      return File(filePath).writeAsString('');
    }
  }
  Future<bool> checkExist(String filename) async {
    final dir = await _localPath;
    final filePath = '$dir/$filename';
    if (!await Directory(File(filePath).parent.path).exists()) {
      await Directory(File(filePath).parent.path).create();
    }
    if (File(filePath).existsSync()) {
      return true;
    } else {
      return false;
    }
  }
}

enum FileTypeApi { json, xlsx }