import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/widgets/animations.dart';
import 'package:navis/widgets/widgets.dart';

class Deals extends StatelessWidget {
  const Deals({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.subhead;

    return Tiles(
        title: 'Darvo Deals',
        child: BlocBuilder(
          bloc: BlocProvider.of<WorldstateBloc>(context),
          condition: (WorldStates previous, WorldStates current) => listEquals(
              previous.worldstate?.dailyDeals, current.worldstate?.dailyDeals),
          builder: (_, state) {
            final dailyDeals = state.worldstate?.dailyDeals ?? [];

            final header = TableRow(children: <Widget>[
              Text('Item', style: style),
              Text('Discount', style: style),
              Text('Price', style: style),
              Text('Stock', style: style),
              const SizedBox(width: 100)
            ]);

            return Container(
                margin: const EdgeInsets.all(4),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  defaultColumnWidth: FlexColumnWidth(),
                  children: <TableRow>[
                    header,
                    ...dailyDeals.map((d) {
                      final remaining = d.total - d.sold;

                      return TableRow(children: <Widget>[
                        Text(d.item, style: style),
                        Text('${d.discount}%', style: style),
                        Text('${d.salePrice}', style: style),
                        Text('$remaining/${d.total}', style: style),
                        CountdownBox(expiry: d.expiry),
                      ]);
                    })
                  ],
                ));
          },
        ));
  }
}