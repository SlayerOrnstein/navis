import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:navis/features/worldstate/presentation/pages/feed.dart';
import 'package:navis/features/worldstate/presentation/pages/fissures.dart';
import 'package:navis/features/worldstate/presentation/pages/invasions.dart';
import 'package:navis/features/worldstate/presentation/pages/sorties.dart';
import 'package:navis/features/worldstate/presentation/pages/syndicates.dart';

enum NavigationEvent { feed, fissures, invasions, sorties, syndicates, codex }

class NavigationBloc extends HydratedBloc<NavigationEvent, Widget> {
  final _navigationMap = {
    NavigationEvent.feed: const HomeFeedPage(),
    NavigationEvent.fissures: const FissuresPage(),
    NavigationEvent.invasions: const InvasionsPage(),
    NavigationEvent.sorties: const SortiePage(),
    NavigationEvent.syndicates: const SyndicatePage(),
    NavigationEvent.codex: Container()
  };

  @override
  Widget get initialState => const HomeFeedPage();

  @override
  Stream<Widget> transformEvents(Stream<NavigationEvent> events,
      Stream<Widget> Function(NavigationEvent) next) {
    return super.transformEvents(events.distinct(), next);
  }

  @override
  Stream<Widget> mapEventToState(
    NavigationEvent event,
  ) async* {
    yield _navigationMap[event];
  }

  @override
  Widget fromJson(Map<String, dynamic> json) {
    final event =
        NavigationEvent.values.firstWhere((n) => n.toString() == json['key']);

    return _navigationMap[event];
  }

  @override
  Map<String, dynamic> toJson(Widget state) {
    final key =
        _navigationMap.keys.firstWhere((k) => _navigationMap[k] == state);

    return <String, dynamic>{'key': key.toString()};
  }
}