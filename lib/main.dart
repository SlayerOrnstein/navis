import 'package:flutter/material.dart';
import 'package:navis/blocs/provider.dart';
import 'package:navis/blocs/worldstate_bloc.dart';
import 'package:background_fetch/background_fetch.dart';

import 'app.dart';

void main() async {
  final state = WorldstateBloc();
  runApp(BlocProvider<WorldstateBloc>(bloc: state, child: Navis()));

  BackgroundFetch.configure(
      BackgroundFetchConfig(
          startOnBoot: true, stopOnTerminate: false, enableHeadless: true),
      fetchState);
}

void fetchState() async {
  final state = WorldstateBloc();
  state.update();
  BackgroundFetch.finish();
}
