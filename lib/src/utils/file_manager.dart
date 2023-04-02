// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/utils/encrypt_data.dart';

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
        return States.isEXISTS;
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
    File file = await _localFile(folderName, fileName);

    try {
      final fileContent = await file.readAsString();
      if (fileContent.isNotEmpty) {
        return Json.tryDecode(EncryptData.decryptAES(fileContent));
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(States.CANT_READ_FILE);
    }
  }

  /// write and encode jsonFile
  Future<String> writeJsonFile(
      String folderName, String fileName, dynamic jsonContext) async {
    File file = await _localFile(folderName, fileName);

    try {
      file.writeAsStringSync(
          EncryptData.encryptAES(Json.tryEncode(jsonContext).toString()));
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
      return json.encode(data);
    } catch (e) {
      return null;
    }
  }

  static dynamic tryDecode(String data) {
    try {
      return json.decode(data);
    } catch (e) {
      return null;
    }
  }
}
