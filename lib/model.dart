import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'animation/countdown.dart';
import 'json/export.dart';
import 'services/state.dart';

class NavisModel extends Model {
  final SystemState state;
  final DateFormat _format = DateFormat.jms().add_yMd();

  bool _isLoading = false;
  bool _hasError = false;
  WorldState _worldState;

  NavisModel({this.state});

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  Cetus get cetus => _worldState.cetus;

  Earth get earth => _worldState.earth;

  Sortie get sortie => _worldState.sortie;

  VoidTrader get trader => _worldState.trader;

  List<Alerts> get alerts => _worldState.alerts;

  List<Events> get events => _worldState.events;

  List<VoidFissures> get fissures => _worldState.voidFissures;

  List<OrbiterNews> get news => _worldState.news;

  List<PersistentEnemies> get enemies => _worldState.persistentEnemies;

  List<Syndicates> get syndicates => _worldState.syndicates;

  Invasions get oneInvasion {
    final rand = Random.secure();
    final one = rand.nextInt(_worldState.invasions.length);

    return _worldState.invasions[one];
  }

  Stream<Duration> get cetusTime {
    String expiry = _worldState.cetus.expiry;
    bool isDay = _worldState.cetus.isDay;
    Duration time;

    try {
      time = DateTime.parse(expiry).difference(DateTime.now());
    } catch (err) {
      time = isDay ? Duration(minutes: 100) : Duration(minutes: 50);
    }

    if (expiry == null && isDay) {
      return CounterScreenStream(Duration(minutes: 100));
    } else if (expiry == null && isDay == false) {
      return CounterScreenStream(Duration(minutes: 50));
    } else if (time < Duration.zero && isDay) {
      return CounterScreenStream(Duration(minutes: 100));
    } else if (time < Duration.zero && isDay == false) {
      return CounterScreenStream(Duration(minutes: 50));
    } else {
      return CounterScreenStream(time);
    }
  }

  Stream<Duration> get earthTime => CounterScreenStream(
      DateTime.parse(_worldState.earth.expiry).difference(DateTime.now()));

  String get cetusExpiry {
    if (_worldState.cetus.expiry == null) {
      Future.delayed(Duration(minutes: 1));
      update();
      _format.format(DateTime.parse(_worldState.cetus.expiry).toLocal());
    } else
      return _format.format(DateTime.parse(_worldState.cetus.expiry).toLocal());
  }

  String get earthExpiry =>
      _format.format(DateTime.parse(_worldState.earth.expiry).toLocal());

  String get arrival =>
      _format.format(DateTime.parse(_worldState.trader.activation).toLocal());

  String get departure =>
      _format.format(DateTime.parse(_worldState.trader.expiry).toLocal());

  Future<Null> update() async {
    _isLoading = true;
    notifyListeners();

    return state.updateState().then((data) async {
      _worldState = data;
      _isLoading = false;
      _hasError = false;
      notifyListeners();
    }).catchError((error) {
      _hasError = true;
      _isLoading = false;
      print('$error');
      notifyListeners();
    });
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  static NavisModel of(BuildContext context) =>
      ModelFinder<NavisModel>().of(context);
}
