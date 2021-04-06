import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> localFile(String fileName) async {
    final path = await _localPath;
    
    return File('$path/$fileName');
  }

  Future<File> readImage(String fileName) async {
    try {
      final file = await localFile(fileName);

      bool obstaja = await file.exists();

      if (obstaja == false)
        return File('');

      return file;

    } catch (e) {

      return File('');
    }
  }
}
