import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:matomo/matomo.dart';
import 'package:wfcd_client/wfcd_client.dart';

import '../../constants/storage_keys.dart';

class Usersettings {
  Usersettings._(this._box);

  final Box<dynamic> _box;

  static Usersettings? _instance;

  static Future<Usersettings> initUsersettings() async {
    log('Initializing Usersettings Hive', level: Level.INFO.value);
    final box = await Hive.openBox<dynamic>('user_settings');

    return _instance ??= Usersettings._(box);
  }

  // Application wise we don't need to ever close the box, since restarting the
  // app already discards it, so we only need this to delete the box during
  // testing on one system multiple times.
  @visibleForTesting
  Future<void> close() => _box.close();

  Locale? get language {
    final value = _box.get(SettingsKeys.userLanguage) as String?;

    if (value != null) {
      return Locale(value);
    }

    return null;
  }

  void setLanguage(Locale? value) {
    if (value != null) {
      log('setting new lang ${value.languageCode}', level: Level.INFO.value);
      _box.put(SettingsKeys.userLanguage, value.languageCode);
    }
  }

  GamePlatforms get platform {
    final value = _box.get(SettingsKeys.platformKey) as String?;

    if (value != null) {
      return GamePlatformsX.fromString(value);
    }

    return GamePlatforms.pc;
  }

  set platform(GamePlatforms value) {
    log('setting new platform ${value.asString}', level: Level.INFO.value);
    _box.put(SettingsKeys.platformKey, value.asString);
  }

  ThemeMode get theme {
    final value = _box.get(SettingsKeys.theme) as String?;

    return ThemeMode.values.firstWhere(
      (e) => e.toString().contains(value ?? ''),
      orElse: () => ThemeMode.system,
    );
  }

  set theme(ThemeMode mode) {
    _box.put(SettingsKeys.theme, mode.toString().split('.').last);
  }

  bool get backkey => getToggle(SettingsKeys.backKey);

  set backkey(bool value) => setToggle(SettingsKeys.backKey, value);

  bool get isOptOut => getToggle(MatomoTracker.kOptOut);

  set isOptOut(bool value) => setToggle(MatomoTracker.kOptOut, value);

  bool get isFirstTime =>
      getToggle(SettingsKeys.isFirstTime, defaultValue: true);

  set isFirstTime(bool value) => setToggle(SettingsKeys.isFirstTime, value);

  bool getToggle(String key, {bool defaultValue = false}) {
    return _box.get(key, defaultValue: defaultValue) as bool;
  }

  void setToggle(String key, bool value) {
    _box.put(key, value);
  }
}
