import 'dart:io';

import 'package:flutter/foundation.dart';

//third party
import 'package:sembast/sembast.dart';

//model
import '../models/download_model.dart';

//db helper
import '../helpers/db_helper.dart';

class DownloadProvider with ChangeNotifier {
  static const String MEDIA_STORE_NAME = 'media';

  final _mediaStore = intMapStoreFactory.store(MEDIA_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  List<DownloadModel> _downLoads = [];
  List<DownloadModel> get downloads {
    return [..._downLoads].reversed.toList();
  }

  Future<void> download(DownloadModel download) async {
    try {
      await _mediaStore.add(await _db, download.toMap());
      _downLoads.add(
        download,
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> hasBeenDownloaded(String id) async {
    try {
      final finder = Finder(
        filter: Filter.equals(
          'id',
          id,
        ),
      );
      final value = await _mediaStore.findFirst(
        await _db,
        finder: finder,
      );

      if (value != null) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> delete(String id, String path) async {
    try {
      final finder = Finder(
        filter: Filter.equals(
          'id',
          id,
        ),
      );
      await _mediaStore.delete(
        await _db,
        finder: finder,
      );
      await File(
        path,
      ).delete();
      _downLoads.removeWhere((download) => download.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fectchAndSetDownloads() async {
    try {
      final downloads = [];
      final recordSnapshots = await _mediaStore.find(
        await _db,
      );

      if (recordSnapshots.isNotEmpty) {
        recordSnapshots.forEach((element) {
          var download = DownloadModel.fromSembast(
            element.value,
          );

          if (File(download.downloadPath).existsSync()) {
            downloads.add(download);
          }
        });
      }

      _downLoads = [...downloads];
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
