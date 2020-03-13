import 'package:flutter/material.dart';
import 'package:navis/utils/helper_utils.dart';
import 'package:worldstate_api_model/misc.dart';

class DropResultWidget extends StatelessWidget {
  const DropResultWidget({Key key, this.drop}) : super(key: key);

  final SlimDrop drop;

  // Color _chance(num chance) {
  //   if (chance < 25) return Colors.yellow;
  //   if (chance > 25 && chance < 50) return Colors.white;

  //   return Colors.brown;
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(drop.item),
      subtitle:
          Text('${parseHtmlString(drop.place)} | ${drop.chance}% Drop Chance'),
      dense: true,
    );
  }
}