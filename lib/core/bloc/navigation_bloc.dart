import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import '../../features/codex/presentation/pages/codex_search_screen.dart';
import '../../features/synthtargets/presentation/pages/targets.dart';
import '../../features/worldstate/presentation/pages/home.dart';
import '../../features/worldstate/presentation/pages/orbiter_news.dart';

enum NavigationEvent { timers, warframeNews, codex, synthTargets }

class NavigationBloc extends Bloc<NavigationEvent, Widget> {
  NavigationBloc() : super(navigationMap[NavigationEvent.timers]);

  static final Map<NavigationEvent, Widget> navigationMap = {
    NavigationEvent.timers: const HomeFeedPage(),
    NavigationEvent.warframeNews: const OrbiterNewsPage(),
    NavigationEvent.codex: const CodexSearchScreen(),
    NavigationEvent.synthTargets: const SynthTargetsPage()
  };

  @override
  Stream<Transition<NavigationEvent, Widget>> transformEvents(
    Stream<NavigationEvent> events,
    TransitionFunction<NavigationEvent, Widget> transitionFn,
  ) {
    return events.switchMap(transitionFn);
  }

  @override
  Stream<Widget> mapEventToState(
    NavigationEvent event,
  ) async* {
    yield navigationMap[event];
  }
}
