import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/blocs/worldstate/worldstate_events.dart';
import 'package:navis/services/wfcd_api/worldstate_api.service.dart';
import 'package:worldstate_model/worldstate_models.dart';

import '../mock_classes.dart';
import '../setup_methods.dart';

void main() {
  final worldstateJson = File('./worldstate.json').readAsStringSync();
  final worldstate = Worldstate.fromJson(json.decode(worldstateJson));

  WorldstateApiService api;
  WorldstateBloc worldstateBloc;

  setUpAll(() async {
    await mockSetup();

    api = MockWorldstateApiService();
    worldstateBloc = WorldstateBloc(api);
  });

  test('Enusre that Worldstate is Loaded', () async {
    when(api.getWorldstate()).thenAnswer((_) => Future.value(worldstate));

    worldstateBloc.add(UpdateEvent());

    await Future.delayed(const Duration(milliseconds: 900));

    expectLater(worldstateBloc.state, WorldstateLoaded(worldstate));
  });
}
