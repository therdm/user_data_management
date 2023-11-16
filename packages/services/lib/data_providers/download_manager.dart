import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadManager {

  static Future<String> download(dynamic data, String fileName) async {
    final fullPath = await getDefaultFilePath(fileName);
    final File file = File(fullPath);
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(data as Uint8List);
    await raf.close();
    return fullPath;
  }

  static Future<void> downloadAndOpen(dynamic data, String fileName) async {
    await OpenFile.open(await download(data, fileName));
  }


  static Future<void> open(String fileName) async {
    final fullPath = await getDefaultFilePath(fileName);
    await OpenFile.open(fullPath);
  }
  static Future<String> getDefaultFilePath(String fileName) async {
    final tempDir = await getTemporaryDirectory();
    return tempDir.path + fileName;
  }
}
