import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/constants/storage_keys.dart';
import 'package:navis/services/repository.dart';
import 'package:navis/utils/utils.dart';

import 'base_dialog.dart';

class DateFormatPicker extends StatelessWidget {
  static Future<void> selectDateformat(BuildContext context) async {
    showDialog(context: context, builder: (_) => DateFormatPicker());
  }

  @override
  Widget build(BuildContext context) {
    final storage = RepositoryProvider.of<Repository>(context).storage;

    return WatchBoxBuilder(
      box: storage.instance,
      watchKeys: const [SettingsKeys.dateformatKey],
      builder: (BuildContext context, Box box) {
        return BaseDialog(
            dialogTitle: const Text('Select Dateformat'),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              for (Formats v in Formats.values)
                DateFormatRadioListTile(
                  value: v,
                  groupValue: storage.dateformat,
                  onChanged: (value) {
                    storage.dateformat = value;
                    Navigator.of(context).pop();
                  },
                )
            ]),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ]);
      },
    );
  }
}

class DateFormatRadioListTile extends StatelessWidget {
  const DateFormatRadioListTile({
    Key key,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
  }) : super(key: key);

  final Formats value;
  final Formats groupValue;
  final ValueChanged<Formats> onChanged;

  @override
  Widget build(BuildContext context) {
    final String format = value.toString().split('.').last;

    return RadioListTile<Formats>(
      title: Text(format),
      value: value,
      groupValue: groupValue,
      activeColor: Theme.of(context).accentColor,
      onChanged: onChanged,
    );
  }
}