// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:todoon/src/constants/states.dart';

class FileManager {
  static final FileManager instance = FileManager();

  /// load Application Documents path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// load File from Application Documents / folderName
  Future<File> _localFile(String folderName, String fileName) async {
    final path = await _localPath;
    return File('$path/$folderName/$fileName');
  }

  /// create jsonFile
  Future<String> createJsonFile(String folderName, String fileName) async {
    try {
      final file = await _localFile(folderName, fileName);

      /// if exist return else create
      if (file.existsSync()) {
        return States.isEXIST;
      } else {
        file.createSync(recursive: true);
        return States.CREATED_FILE;
      }
    } catch (e) {
      throw Exception(States.CANT_CREATE_FILE);
    }
  }

  /// read and decode jsonFile
  Future<dynamic> readJsonFile(String folderName, String fileName) async {
    String jsonContent = '[]';
    File file = await _localFile(folderName, fileName);

    try {
      final fileContent = await file.readAsString();
      jsonContent = fileContent;
      return Json.tryDecode(jsonContent);
    } catch (e) {
      throw Exception(States.CANT_READ_FILE);
    }
  }

  /// write and encode jsonFile
  Future<String> writeJsonFile(
      String folderName, String fileName, dynamic jsonContext) async {
    File file = await _localFile(folderName, fileName);

    try {
      file.writeAsStringSync(Json.tryEncode(jsonContext).toString());
      return States.TRUE;
    } catch (e) {
      throw Exception(States.CANT_WRITE_FILE);
    }
  }
}

/// Json try to jsonEncode and jsonDecode
class Json {
  static String? tryEncode(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      return null;
    }
  }

  static dynamic tryDecode(data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return null;
    }
  }
}
