import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/resources/storage/persistent.dart';

class PersistentWatcher extends StatelessWidget {
  const PersistentWatcher({Key key, this.builder}) : super(key: key);

  final ValueWidgetBuilder<Box<dynamic>> builder;

  @override
  Widget build(BuildContext context) {
    final persistent = RepositoryProvider.of<PersistentResource>(context);

    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: persistent.watchBox(),
      builder: builder,
    );
  }
}
