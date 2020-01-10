import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class DropTableClient {
  const DropTableClient();

  static const _baseUrl = 'https://drops.warframestat.us/data';

  /// Retrives the latest timestamp generated by WFCD
  Future<DateTime> dropsTimestamp() async {
    final info = json.decode(await _warframestatDrops('info.json'))
        as Map<String, dynamic>;

    return DateTime.fromMillisecondsSinceEpoch(info['timestamp'] as int);
  }

  /// Downloads the latest avialable version of the warframe drop table
  Future<void> downloadDropTable(File file) async {
    final response = await _warframestatDrops('all.slim.json');

    await file.writeAsString(response);
  }

  Future<String> _warframestatDrops(String path) async {
    final response = await http.get('$_baseUrl/$path');

    return response.body;
  }
}
