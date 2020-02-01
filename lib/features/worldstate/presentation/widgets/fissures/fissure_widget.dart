import 'package:flutter/material.dart';
import 'package:navis/core/widgets/cards.dart';
import 'package:navis/core/widgets/countdown.dart';
import 'package:worldstate_api_model/worldstate_models.dart';

import 'relic_icons.dart';

class FissureWidget extends StatelessWidget {
  const FissureWidget({Key key, this.fissure}) : super(key: key);

  final VoidFissure fissure;

  IconData _getIcon() {
    switch (fissure.tier) {
      case 'Lith':
        return RelicIcons.lith;
      case 'Meso':
        return RelicIcons.meso;
      case 'Neo':
        return RelicIcons.neo;
      case 'Axi':
        return RelicIcons.axi;
      default:
        return RelicIcons.requiem;
    }
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    const shadow = Shadow(offset: Offset(1.0, 0.0), blurRadius: 3.0);

    const _nodeStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      fontSize: 18,
      color: color,
      shadows: <Shadow>[shadow],
    );

    const _missionTypeStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      color: color,
      shadows: <Shadow>[shadow],
    );

    return Panel(
      child: ListTile(
        leading: Icon(_getIcon()),
        title: Text(fissure.node, style: _nodeStyle),
        subtitle: Text(
          '${fissure.missionType} | ${fissure.tier}',
          style: _missionTypeStyle,
        ),
        trailing: CountdownTimer(expiry: fissure.expiry),
      ),
    );
  }
}
