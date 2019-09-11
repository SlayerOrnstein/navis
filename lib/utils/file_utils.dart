import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> checkFile(String path) async =>
    File(await tempDirectory() + path).existsSync();

Future<File> getFile(String path) async => File(await tempDirectory() + path);

Future<String> tempDirectory() async {
  final directory = await getTemporaryDirectory();

  return directory.path;
}

Future<File> saveFile(SaveFile save) async {
  return await compute(_saveFile, save);
}

Future<File> _saveFile(SaveFile save) async {
  final file = File(save.path);

  return file.writeAsString(save.data);
}

class SaveFile {
  SaveFile(this.path, this.data);

  String path;
  String data;
}