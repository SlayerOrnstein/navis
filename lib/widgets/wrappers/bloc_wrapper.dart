import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/blocs/worldstate/worldstate_bloc.dart';
import 'package:navis/repository/repositories.dart';

class BlocWrapper extends StatelessWidget {
  const BlocWrapper({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final worldstateRepository =
        RepositoryProvider.of<WorldstateRepository>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<WorldstateBloc>(
          create: (_) => WorldstateBloc(worldstateRepository),
        ),
        BlocProvider<NavigationBloc>(create: (_) => NavigationBloc())
      ],
      child: child,
    );
  }
}