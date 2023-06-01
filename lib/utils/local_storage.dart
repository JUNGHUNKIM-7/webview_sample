import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathHandler {
  PathHandler._();

  static Directory? _tempdir;
  static Directory? _appDir;

  factory PathHandler.getInstance() => PathHandler._();

  static Future<void> initialize() async {
    final dir = await Future.wait([
      getTemporaryDirectory(),
      getApplicationDocumentsDirectory(),
    ]);
    if (await dir.first.exists() && await dir.last.exists()) {
      _tempdir = dir.first;
      _appDir = dir.last;
      return;
    }
    if (!await dir.first.exists()) await dir.first.create();
    if (!await dir.last.exists()) await dir.last.create();
  }

  void _checkInit() {
    if (_tempdir == null || _appDir == null) {
      throw Exception('PathHandler not initialized');
    }
  }

  Future<void> gen(String subDir) async {
    _checkInit();
    try {
      await File('${_appDir!.path}/$subDir').writeAsString('contents');
    } catch (e) {
      throw Exception('PathHandler gen error: $e');
    }
  }
}
