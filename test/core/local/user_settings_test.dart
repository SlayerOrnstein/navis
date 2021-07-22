import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/navis_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:navis/core/local/user_settings.dart';
import 'package:navis/core/utils/notification_filter.dart';
import 'package:navis/l10n/l10n.dart';
import 'package:wfcd_client/wfcd_client.dart';

Future<void> main() async {
  final temp = await Directory.systemTemp.createTemp();

  late Usersettings settings;

  setUpAll(() async {
    Hive.init(temp.path);
    settings = await Usersettings.initUsersettings();
  });

  tearDownAll(() async {
    await settings.close();
    await temp.delete(recursive: true);
  });

  group('Test system settings', () {
    test('Test language toggles', () {
      for (final locale in NavisLocalizations.supportedLocales) {
        settings.setLanguage(locale);
        expect(settings.language, locale);
      }
    });

    test('Test platform toggles', () {
      for (final platform in GamePlatforms.values) {
        settings.platform = platform;
        expect(settings.platform, platform);
      }
    });

    test('Test theme toggles', () {
      // Make sure that it returns ThemeMode.system by default
      expect(settings.theme, ThemeMode.system);

      for (final mode in ThemeMode.values) {
        settings.theme = mode;
        expect(settings.theme, mode);
      }
    });

    test('Test back key enable/disable toggle', () {
      // Make sure the default value is false.
      expect(settings.backkey, false);

      settings.backkey = true;
      expect(settings.backkey, true);

      settings.backkey = false;
      expect(settings.backkey, false);
    });

    test('Test analytics enable/disable toggle', () {
      // Make sure the default value is false.
      expect(settings.isOptOut, false);

      settings.isOptOut = true;
      expect(settings.isOptOut, true);

      settings.isOptOut = false;
      expect(settings.isOptOut, false);
    });

    test('Test first time opening app value', () {
      // Make sure the default value is true.
      expect(settings.isFirstTime, true);

      settings.isFirstTime = false;
      expect(settings.isFirstTime, false);

      settings.isFirstTime = true;
      expect(settings.isFirstTime, true);
    });
  });

  group('Test notification toggles', () {
    final enLocale = NavisLocalizationsEn();
    final filters = LocalizedFilter(enLocale);

    void runToggleTest(Iterable<String> keys) {
      for (final k in keys) {
        // Make sure the default value is false.
        expect(settings.getToggle(k), false);

        settings.setToggle(k, true);
        expect(settings.getToggle(k), true);

        settings.setToggle(k, false);
        expect(settings.getToggle(k), false);
      }
    }

    test('Test simple filter toggle', () {
      runToggleTest(filters.simpleFilters.map((e) => e['key']!));
    });

    test('Test planet filter enable/disable toggles', () {
      runToggleTest(filters.planetCycles.keys);
    });

    test('Test warframe news filter enable/disable toggles', () {
      runToggleTest(filters.warframeNews.keys);
    });

    test('Test acolytes filter enable/disable toggles', () {
      runToggleTest(filters.acolytes.keys);
    });

    test('Test resource filter enable/disable toggles', () {
      runToggleTest(filters.resources.keys);
    });

    test('Test fissure filter enable/disable toggles', () {
      runToggleTest(filters.fissures.keys);
    });
  });
}
