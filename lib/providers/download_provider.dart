import 'package:flutter/widgets.dart';
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
    return [..._downLoads];
  }

  Future<void> download(DownloadModel download) async {
    try {
      await _mediaStore.add(await _db, download.toMap());
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> hasBeenDownloaded(String id) async {
    print("Running has been downloaded");
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
         print("has been downloaded");
        return true;
      }
       print("has not been downloaded");
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future delete(String id) async {
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
          downloads.add(DownloadModel.fromSembast(element.value));
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
