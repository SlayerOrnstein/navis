//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navis/blocs/provider.dart';
import 'package:navis/blocs/worldstate_bloc.dart';
import 'package:navis/models/alerts.dart';
import 'package:navis/models/events.dart';
import 'package:navis/models/worldstate.dart';

import '../../resources/assets.dart';
import '../widgets/cards.dart';
import '../widgets/timer.dart';

class AlertTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alert = BlocProvider.of<WorldstateBloc>(context);

    return StreamBuilder<WorldState>(
        initialData: alert.lastState,
        stream: alert.worldstate,
        builder: (BuildContext context, AsyncSnapshot<WorldState> snapshot) {
          List<Widget> allAlerts = snapshot.data.alerts
              .map((alert) => _buildAlerts(alert, context))
              .toList();

          if (snapshot.data.events.isNotEmpty &&
              snapshot.data.events[0].description.contains('Tactical Alert')) {
            allAlerts.insertAll(
                0,
                snapshot.data.events
                    .where((e) => e.tooltip.contains('Tac Alert') == true)
                    .map((e) => _buildTacticalAlerts(e, alert, context)));
          }

          return Tiles(
              child: Container(
                  child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Alerts', style: TextStyle(fontSize: 19.0))
                  ]),
            ),
            Divider(
              color: Theme.of(context).accentColor,
            ),
            Column(children: allAlerts)
          ])));
        });
  }
}

Widget _buildTacticalAlerts(
    Events alert, WorldstateBloc bloc, BuildContext context) {
  Duration timeLeft = DateTime.parse(alert.expiry).difference(DateTime.now());

  return Padding(
    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
    child: Container(
      padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(alert.description,
                            style: TextStyle(fontSize: 15.0)),
                        Timer(duration: timeLeft, isEvent: true),
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: alert.rewards.map((r) {
                          return Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent[400],
                                  borderRadius: BorderRadius.circular(3.0)),
                              child: Text(r.itemString,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body2));
                        }).toList()),
                  )
                ])
          ]),
    ),
  );
}

Widget _buildAlerts(Alerts alert, BuildContext context) {
  Duration timeLeft = DateTime.parse(alert.expiry).difference(DateTime.now());

  return Padding(
    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
    child: Container(
      padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Row(children: <Widget>[
                        _specialMission(alert.mission.nightmare,
                            alert.mission.archwingRequired),
                        Text(alert.mission.node,
                            style: TextStyle(fontSize: 15.0))
                      ])),
                  alert.mission.reward.itemString.isEmpty
                      ? Container(
                    height: 0.0,
                    width: 0.0,
                  )
                      : Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent[400],
                          borderRadius: BorderRadius.circular(3.0)),
                      child: Text(
                        alert.mission.reward.itemString,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body2,
                      )),
                ]),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        '${alert.mission.type} (${alert.mission
                            .faction}) | Level: ${alert.mission
                            .minEnemyLevel} - ${alert.mission
                            .maxEnemyLevel} | ${alert.mission.reward
                            .credits}cr',
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .textTheme
                                .caption
                                .color)),
                    Timer(isMore1H: true, duration: timeLeft)
                  ]),
            ),
          ]),
    ),
  );
}

Widget _specialMission(bool nightmare, bool archwing) {
  if (archwing && nightmare)
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(
          child: Row(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Icon(ImageAssets.nightmare),
        ),
        Icon(ImageAssets.archwing)
      ])),
    );
  else if (archwing)
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(child: Icon(ImageAssets.archwing)),
    );
  else if (nightmare)
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(child: Icon(ImageAssets.nightmare)),
    );
  else
    return Container(
      height: 0.0,
      width: 0.0,
    );
}
