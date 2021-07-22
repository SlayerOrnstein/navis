import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:market_client/market_client.dart';

class MarketCache {
  const MarketCache._(this._box);

  final Box<dynamic> _box;

  static MarketCache? _instance;

  static Future<MarketCache> initCache() async {
    log('Initializing MarketCache Hive');
    final box = await Hive.openBox<dynamic>('market_cache').catchError(
      (Object error, StackTrace stack) {
        log('Unable to open Hive box', error: error, stackTrace: stack);
      },
    );

    return _instance ??= MarketCache._(box);
  }

  static const _timestamp = 'timestamp';
  static const _itemName = 'itemName';
  static const _ordersKey = 'marketOrders';

  void cacheOrders(String itemName, List<ItemOrder> orders) {
    _box
      ..put(_timestamp, DateTime.now())
      ..put(_itemName, itemName)
      ..put(_ordersKey, json.encode(orders.map((o) => o.toJson()).toList()));
  }

  String? getCachedItemName() {
    return _box.get(_itemName);
  }

  DateTime? getTimestamp() {
    return _box.get(_timestamp);
  }

  List<ItemOrder>? getCachedOrders() {
    final cached = _box.get(_ordersKey);

    if (cached != null) {
      final orders = json.decode(cached) as List<dynamic>;

      return orders
          .map((e) => ItemOrder.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return null;
  }
}
