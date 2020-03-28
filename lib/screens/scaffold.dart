import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/blocs/worldstate/worldstate_events.dart';
import 'package:navis/global_keys.dart';
import 'package:navis/services/repository.dart';
import 'package:navis/widgets/drawer/drawer.dart';
import 'package:navis/widgets/scaffold/scaffold_body.dart';
import 'package:navis/widgets/scaffold/scaffold_listener.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 5), (t) {
      BlocProvider.of<WorldstateBloc>(context).add(UpdateEvent());
    });

    RepositoryProvider.of<Repository>(context).updateDropTable();
  }

  Future<bool> _willPop() async {
    final Box box =
        RepositoryProvider.of<Repository>(context).persistent.hiveBox;

    if (box.get('backkey', defaultValue: false)) {
      if (!appScaffold.currentState.isDrawerOpen) {
        appScaffold.currentState.openDrawer();
        return false;
      } else
        return true;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        key: appScaffold,
        appBar: AppBar(title: const Text('Navis')),
        drawer: const LotusDrawer(),
        body: const ScaffoldListenerWidget(
          child: ScaffoldBody(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    RepositoryProvider.of<Repository>(context).persistent.closeBoxInstance();
    RepositoryProvider.of<Repository>(context).cache.closeBoxInstance();
    super.dispose();
  }
}