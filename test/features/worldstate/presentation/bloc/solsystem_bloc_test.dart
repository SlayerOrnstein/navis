import 'dart:convert';
import 'dart:io';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navis/core/error/exceptions.dart';
import 'package:navis/features/worldstate/domain/usecases/get_worldstate.dart';
import 'package:navis/features/worldstate/presentation/bloc/solsystem_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';
import 'package:wfcd_client/models.dart';
import 'package:wfcd_client/wfcd_client.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetWorldstate extends Mock implements GetWorldstate {}

void main() {
  final worldstateFixture = fixture('worldstate.json');
  final tWorldstate =
      toWorldstate(json.decode(worldstateFixture) as Map<String, dynamic>);

  late GetWorldstate getWorldstate;
  late SolsystemBloc solsystemBloc;

  setUpAll(() async {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await Directory.systemTemp.createTemp(),
    );

    getWorldstate = MockGetWorldstate();
    solsystemBloc = SolsystemBloc(getWorldstate: getWorldstate);
  });

  tearDownAll(() {
    solsystemBloc
      ..clear()
      ..close();
  });

  test('Test the initial State should be SolsystemInitial', () {
    expect(solsystemBloc.state, equals(SolsystemInitial()));
  });

  test('Test should sync solsystem status', () async {
    when(() => getWorldstate(any())).thenAnswer((_) async => Ok(tWorldstate));

    await solsystemBloc.update();
    await untilCalled(() => getWorldstate(any()));

    verify(() => getWorldstate(false));
    expect(solsystemBloc.state, SolState(tWorldstate));
  });

  group('Test bloc exceptions', () {
    test('Server exception is throw', () async {
      when(() => getWorldstate(any())).thenThrow(ServerException());

      await solsystemBloc.update();
      await untilCalled(() => getWorldstate(any()));

      verify(() => getWorldstate(false));
      expect(solsystemBloc.state, const SystemError(serverFailureMessage));
    });

    test('Cache exception is thrown', () async {
      when(() => getWorldstate(any())).thenThrow(CacheException());

      await solsystemBloc.update();
      await untilCalled(() => getWorldstate(any()));

      verify(() => getWorldstate(false));
      expect(solsystemBloc.state, const SystemError(cacheFailureMessage));
    });
  });

  test(
    'Test to make sure the worldstate was saved into the Hydrated hive box',
    () async {
      when(() => getWorldstate(any())).thenAnswer((_) async => Ok(tWorldstate));
      await solsystemBloc.update();

      final cached = HydratedBloc.storage.read(solsystemBloc.storageToken);
      final worldstate = WorldstateModel.fromJson(cached);

      expect(worldstate, tWorldstate);
    },
  );
}
