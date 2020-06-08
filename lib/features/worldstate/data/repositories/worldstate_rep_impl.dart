import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:navis/core/local/user_settings.dart';
import 'package:navis/core/local/warframestate_local.dart';
import 'package:navis/core/network/warframestat_remote.dart';
import 'package:warframestat_api_models/entities.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/worldstate_repository.dart';

class WorldstateRepositoryImpl implements WorldstateRepository {
  WorldstateRepositoryImpl(this.networkInfo, this.cache, this.usersettings);

  final NetworkInfo networkInfo;
  final WarframestatCache cache;
  final Usersettings usersettings;

  static final _warframestat = WarframestatClient(http.Client());

  @override
  Future<Either<Failure, List<SynthTarget>>> getSynthTargets() async {
    return run<List<SynthTarget>, void>(
      _getTargets,
      null,
      cache.cacheSynthTargets,
      cache.getCachedTargets,
    );
  }

  @override
  Future<Either<Failure, Worldstate>> getWorldstate() async {
    return run<Worldstate, GamePlatforms>(
      _getWorldstate,
      usersettings.platform,
      cache.cacheWorldstate,
      cache.getCachedState,
    );
  }

  @override
  Future<Either<Failure, BaseItem>> getDealInfo(String id, String name) async {
    final cachedId = cache.getCachedDealId();

    Either<Failure, BaseItem> getCached() {
      try {
        return Right(cache.getCachedDeal(id));
      } catch (e) {
        return Left(CacheFailure());
      }
    }

    if (cachedId != id) {
      if (await networkInfo.isConnected) {
        try {
          final deal = await compute(_getDealInfo, name);
          cache.cacheDealInfo(id, deal);

          return Right(deal);
        } on SocketException {
          return Left(OfflineFailure());
        }
      } else {
        return getCached();
      }
    } else {
      return getCached();
    }
  }

  static Future<Worldstate> _getWorldstate(GamePlatforms platform) {
    return _warframestat.getWorldstate(platform);
  }

  // Becasue compute needs an entry argument noParam can be anything
  static Future<List<SynthTarget>> _getTargets(dynamic noParam) {
    return _warframestat.getSynthTargets();
  }

  static Future<BaseItem> _getDealInfo(String name) async {
    final results = await _warframestat.searchItems(name);

    return results.firstWhere(
      (r) => r.name.toLowerCase().contains(name.toLowerCase()),
      orElse: () => null,
    );
  }

  Future<Either<Failure, T>> run<T, P>(
    Future<T> Function(P) callback,
    P param,
    void Function(T) caching,
    T Function() restore,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await compute<P, T>(callback, param);
        caching(result);

        return Right(result);
      } on SocketException {
        return Left(OfflineFailure());
      }
    } else {
      try {
        return Right(restore());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }
}

class DealRequest {
  const DealRequest(this.id, this.name);

  final String id;
  final String name;
}