import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:navis/services/localstorage_service.dart';
import 'package:navis/utils/file_utils.dart';
import 'package:navis/utils/worldstate_utils.dart';
import 'package:warframe_items_model/warframe_items_model.dart';
import 'package:wfcd_api_wrapper/worldstate_wrapper.dart';
import 'package:worldstate_model/worldstate_models.dart';

class WorldstateService {
  WorldstateService(this.client, this.storage)
      : _api = WorldstateApiWrapper(client);

  final http.Client client;
  final LocalStorageService storage;

  final WorldstateApiWrapper _api;

  static const dropTablePath = '/drop_table.json';

  Future<List<ItemObject>> search(String searchTerm) async {
    return compute(_search, searchTerm);
  }

  Future<ItemObject> getDeal(DarvoDeal deal) async {
    const cacheKey = 'dealId';
    final cachedID = storage.getFromDisk(cacheKey);

    if (cachedID != deal.id) {
      final item = await _api.getItem(deal.item);

      storage.saveToDisk('dealId', deal.id);
      storage.saveToDisk('deal', json.encode(item.toJson()));

      return item;
    }

    final item = json.decode(storage.getFromDisk('deal'));

    return BasicItem.fromJson(item);
  }

  Future<Worldstate> getWorldstate([Platforms platform]) async {
    final worldstate =
        await _api.getWorldstate(platform ?? storage.platform ?? Platforms.pc);

    return cleanState(worldstate);
  }

  Future<File> initializeDropTable() async {
    final doesFileExist = await checkFile(dropTablePath);
    final timestamp = await _getDropTableTimestamp();

    if (!doesFileExist) {
      await _downloadDropTable();
      storage.saveTimestamp(timestamp);

      return getFile(dropTablePath);
    }

    return getFile('/drop_table.json');
  }

  Future<bool> updateDropTable() async {
    final timestamp = await _getDropTableTimestamp();

    if (timestamp != storage.tableTimestamp) {
      await _downloadDropTable();

      storage.saveTimestamp(timestamp);

      return true;
    }

    return false;
  }

  Future<DateTime> _getDropTableTimestamp() async {
    const infoUrl = 'https://drops.warframestat.us/data/info.json';
    final info = json.decode((await client.get(infoUrl)).body);

    return DateTime.fromMillisecondsSinceEpoch(info['timestamp']);
  }

  Future<void> _downloadDropTable([String path]) async {
    const dropTable = 'https://drops.warframestat.us/data/all.slim.json';

    final response = await client.get(dropTable);

    if (response?.statusCode != 200)
      throw Exception(
          'Drop table failed to download. error: ${response?.statusCode}');

    if (!response.body.startsWith('['))
      throw const FormatException('Invalid drop table provided by API');

    await saveFile(
        SaveFile(await tempDirectory() + dropTablePath, response.body));
  }
}

// For some reaason I can pass down the instance and  it causes error on searches so for now
// we simply create a new instance here
Future<List<ItemObject>> _search(String searchTerm) async {
  final api = WorldstateApiWrapper(http.Client());

  return await api.searchItems(searchTerm);
}
