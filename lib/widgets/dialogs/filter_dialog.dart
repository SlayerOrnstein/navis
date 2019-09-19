import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/services/localstorage_service.dart';
import 'package:navis/services/repository.dart';

import 'base_dialog.dart';

enum FilterType { acolytes, news, cycles, fissure }

class FilterDialog extends StatelessWidget {
  const FilterDialog({this.options, this.type});

  final Map<String, String> options;
  final FilterType type;

  static Future<void> showFilters(BuildContext context,
      Map<String, String> options, FilterType type) async {
    showDialog(
        context: context,
        builder: (_) => FilterDialog(options: options, type: type));
  }

  Map<String, bool> _typeToInstance(LocalStorageService storage) {
    switch (type) {
      case FilterType.acolytes:
        return storage.acolytes;
        break;
      case FilterType.news:
        return storage.news;
        break;
      case FilterType.cycles:
        return storage.cycles;
        break;
      case FilterType.fissure:
        return <String, bool>{};
        break;
      default:
        return <String, bool>{};
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = RepositoryProvider.of<Repository>(context).storage;

    return WatchBoxBuilder(
      box: storage.instance,
      watchKeys: options.keys.toList(),
      builder: (BuildContext context, Box box) {
        final instance = _typeToInstance(storage);

        return BaseDialog(
          dialogTitle: const Text('Filter Options'),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            for (String key in options.keys)
              NotificationCheckBox(
                option: options[key],
                optionKey: key,
                value: instance[key],
              )
          ]),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class NotificationCheckBox extends StatelessWidget {
  const NotificationCheckBox(
      {Key key,
      @required this.option,
      @required this.optionKey,
      @required this.value})
      : assert(option != null),
        assert(optionKey != null),
        assert(value != null),
        super(key: key);

  final String option;
  final String optionKey;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final storage = RepositoryProvider.of<Repository>(context).storage;
    final firebase = RepositoryProvider.of<Repository>(context).notifications;

    return CheckboxListTile(
      title: Text(option),
      value: value,
      activeColor: Theme.of(context).accentColor,
      onChanged: (b) {
        storage.saveToDisk(optionKey, b);
        firebase.subscribeToNotification(optionKey, b);
      },
    );
  }
}
