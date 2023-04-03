// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/utils/encrypt_data.dart';

class FileManager {
  static final FileManager instance = FileManager();

  /// Load Application Documents Directory.
  /// @return [String] path of Application Documents Directory.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Load [File] from Application Documents Directory.
  /// @param [folderName] is the name of folder.
  /// @param [fileName] is the name of file.
  /// @return [File] file from Application Documents Directory.
  Future<File> _localFile(String folderName, String fileName) async {
    final path = await _localPath;
    return File(p.join(path, folderName, fileName));
  }

  /// Create jsonFile in Application Documents Directory.
  /// @param [folderName] is the name of folder.
  /// @param [fileName] is the name of file.
  /// @return [String] state of file handle.
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

  /// Read and decode [jsonFile] in Application Documents Directory.
  /// @param [folderName] is the name of folder.
  /// @param [fileName] is the name of file.
  /// @return [Future<dynamic>] json file content.
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

  /// Write and encode [jsonFile] in Application Documents Directory.
  /// @param [folderName] is the name of folder.
  /// @param [fileName] is the name of file.
  /// @param [jsonContext] is the content of file.
  /// @return [String] state of file handle.
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

/// Json class for encode and decode data.
/// @return [String] encoded data.
/// @return [dynamic] decoded data.
/// @return [null] if error.
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
