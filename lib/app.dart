import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/blocs/worldstate/worldstate_events.dart';
import 'package:navis/constants/storage_keys.dart';
import 'package:navis/screens/app_scaffold.dart';
import 'package:navis/screens/codex_entry.dart';
import 'package:navis/screens/nightwaves.dart';
import 'package:navis/screens/syndicate_bounties.dart';
import 'package:navis/screens/trader_inventory.dart';
import 'package:navis/services/repository.dart';
import 'package:navis/utils/size_config.dart';
import 'package:navis/widgets/widgets.dart';
import 'package:wfcd_api_wrapper/worldstate_wrapper.dart';

import 'screens/settings.dart';

class Navis extends StatefulWidget {
  const Navis(this.repository);

  final Repository repository;

  @override
  _NavisState createState() => _NavisState();
}

class _NavisState extends State<Navis> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    BlocProvider.of<WorldstateBloc>(context).dispatch(UpdateEvent());

    if (widget.repository.storage.platform == null) {
      widget.repository.notifications
          .subscribeToPlatform(currentPlatform: Platforms.pc);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      BlocProvider.of<WorldstateBloc>(context).update();
    }

    super.didChangeAppLifecycleState(state);
  }

  Widget _builder(BuildContext context, Widget widget) {
    ErrorWidget.builder =
        (FlutterErrorDetails error) => NavisErrorWidget(details: error);
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: widget.repository,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                SizeConfig().init(constraints, orientation);

                return WatchBoxBuilder(
                  box: widget.repository.storage.instance,
                  watchKeys: const [SettingsKeys.theme],
                  builder: (BuildContext context, Box box) {
                    return MaterialApp(
                      title: 'Navis',
                      color: Colors.grey[900],
                      theme: widget.repository.storage.theme(),
                      home: const MainScreen(),
                      builder: _builder,
                      routes: <String, WidgetBuilder>{
                        Settings.route: (_) => const Settings(),
                        Nightwaves.route: (_) => const Nightwaves(),
                        SyndicateJobs.route: (_) => const SyndicateJobs(),
                        CodexEntry.route: (_) => const CodexEntry(),
                        VoidTraderInventory.route: (_) =>
                            const VoidTraderInventory()
                      },
                    );
                  },
                );
              },
            );
          },
        ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    RepositoryProvider.of<Repository>(context).storage.dispose();
    super.dispose();
  }
}
