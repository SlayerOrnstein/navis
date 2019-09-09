import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:navis/services/worldstate_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:worldstate_model/worldstate_models.dart';

import 'worldstate_states.dart';

enum UpdateEvent { update }

class WorldstateBloc extends HydratedBloc<UpdateEvent, WorldStates> {
  WorldstateBloc(this.api);

  final WorldstateService api;

  @override
  WorldStates get initialState =>
      super.initialState ?? WorldstateUninitialized();

  @override
  Stream<WorldStates> transformEvents(Stream<UpdateEvent> events,
      Stream<WorldStates> Function(UpdateEvent event) next) {
    return super.transformEvents(
        (events as Observable<UpdateEvent>)
            .debounceTime(const Duration(milliseconds: 350)),
        next);
  }

  @override
  Stream<WorldStates> mapEventToState(UpdateEvent event) async* {
    if (event == UpdateEvent.update) {
      try {
        final state = await api.getWorldstate();
        yield WorldstateLoaded(state);
      } catch (e) {
        yield WorldstateError(e.toString());
      }
    }
  }

  Future<void> update() async {
    dispatch(UpdateEvent.update);
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  WorldStates fromJson(Map<String, dynamic> json) {
    return WorldstateLoaded(json as Worldstate);
  }

  @override
  Map<String, dynamic> toJson(WorldStates state) {
    return state.worldstate?.toJson();
  }
}
