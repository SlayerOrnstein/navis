import 'package:flutter/material.dart';
import 'package:navis/blocs/provider.dart';
import 'package:navis/blocs/worldstate_bloc.dart';
import 'package:navis/models/worldstate.dart';
import 'package:navis/ui/widgets/timer.dart';

import '../widgets/cards.dart';

enum Cycle { cetus, earth }

class CetusCycle extends StatefulWidget {
  final Cycle cycle;

  CetusCycle({@required this.cycle});

  @override
  createState() => _CetusCycle();
}

class _CetusCycle extends State<CetusCycle> with TickerProviderStateMixin {
  _cycle(Cycle cycle) {
    switch (cycle) {
      case Cycle.cetus:
        return 'Cetus Day/Night Cycle';
      case Cycle.earth:
        return 'Earth Day/Night Cycle';
    }
  }

  _modelCycle(WorldState state) {
    if (widget.cycle == Cycle.cetus)
      return state.cetus;
    else
      return state.earth;
  }

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<WorldstateBloc>(context);

    final style = TextStyle(
        fontSize: 15.0, color: Theme
        .of(context)
        .textTheme
        .body1
        .color);

    return StreamBuilder<WorldState>(
        initialData: state.lastState,
        stream: state.worldstate,
        builder: (BuildContext context, AsyncSnapshot<WorldState> snapshot) {
          final cycle = _modelCycle(snapshot.data);

          return Tiles(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_cycle(widget.cycle),
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .body1
                                      .color))
                        ],
                      )),
                  Divider(color: Theme
                      .of(context)
                      .accentColor),
                  Container(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Currently it is', style: style),
                          cycle.isDay == true
                              ? RichText(
                              text: TextSpan(
                                  text: 'Day',
                                  style: TextStyle(
                                      color: Colors.yellow[700],
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)))
                              : Text('Night',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold))
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        cycle.isDay == true
                            ? Text('Time until Night', style: style)
                            : Text('Time until Day', style: style),
                        Timer(
                            duration: widget.cycle == Cycle.cetus
                                ? state.cetusCycleTime
                                : state.earthCycleTime,
                            isMore1H: true)
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        cycle.isDay == true
                            ? Text('Time at Night', style: style)
                            : Text('Time at Day', style: style),
                        Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent[400],
                                borderRadius:
                                BorderRadius.all(Radius.circular(3.0))),
                            child: Text(
                                widget.cycle == Cycle.cetus
                                    ? '${state.cetusExpiry}'
                                    : '${state.earthExpiry}',
                                style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  )
                ],
              ));
        });
  }
}
