import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:wfcd_client/entities.dart';
import 'package:wfcd_client/models.dart';
import 'package:wfcd_client/wfcd_client.dart';

class WarframestatCache {
  const WarframestatCache._(this._box);

  final Box<dynamic> _box;

  static WarframestatCache? _instance;

  static Future<WarframestatCache> initCache() async {
    log('Initializing WarframestatCache Hive');
    final box = await Hive.openBox<dynamic>('worldstate_cache').catchError(
      (Object error, StackTrace stack) {
        log(
          'Unable to open Hive box',
          error: error,
          stackTrace: stack,
          level: Level.SEVERE.value,
        );
      },
    );

    return _instance ??= WarframestatCache._(box);
  }

  static const String _dealId = 'dealId';
  static const String _state = 'worldstate';
  static const String _stateTimestamp = 'worldstateTimestamp';
  static const String _targets = 'synthTargets';

  void cacheDealInfo(String id, Item item) {
    _box..put(_dealId, id)..put(id, json.encode(fromBaseItem(item)));
  }

  void cacheSynthTargets(List<SynthTarget> targets) {
    _box.put(_targets, targets.map((t) => (t as SynthTargetModel).toJson()));
  }

  void cacheWorldstate(Worldstate state) {
    _box
      ..put(_stateTimestamp, state.timestamp)
      ..put(_state, json.encode((state as WorldstateModel).toJson()));
  }

  String? getCachedDealId() => readDisk<String>(_dealId);

  Item? getCachedDeal(String id) {
    final cached = readDisk<String>(id);

    if (cached == null) return null;

    return toBaseItem(json.decode(cached) as Map<String, dynamic>);
  }

  DateTime? getCachedStateTimestamp() {
    return readDisk<DateTime>(_stateTimestamp);
  }

  Worldstate? getCachedState() {
    final cached = readDisk<String>(_state);

    if (cached != null) {
      return WorldstateModel.fromJson(
          json.decode(cached) as Map<String, dynamic>);
    }

    return null;
  }

  List<SynthTarget>? getCachedTargets() {
    final cached = readDisk<Iterable<Map<String, dynamic>>>(_targets);

    return cached?.map((t) => SynthTargetModel.fromJson(t)).toList();
  }

  T? readDisk<T>(String key) {
    final cache = _box.get(key) as T?;

    if (cache == null) return null;

    return cache;
  }
}
