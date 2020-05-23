import 'package:flutter/material.dart';
import 'package:navis/core/themes/colors.dart';
import 'package:navis/core/widgets/widgets.dart';
import 'package:navis/features/worldstate/presentation/pages/trader_inventory.dart';
import 'package:navis/generated/l10n.dart';
import 'package:worldstate_api_model/entities.dart';

class TraderCard extends StatelessWidget {
  const TraderCard({Key key, @required this.trader}) : super(key: key);

  final VoidTrader trader;

  Widget _buildButton(BuildContext context, List<InventoryItem> inventory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Material(
        elevation: 2.0,
        color: primary,
        borderRadius: BorderRadius.circular(4.0),
        child: InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed(BaroInventory.route, arguments: inventory),
          child: Container(
              width: 500.0,
              height: 30.0,
              alignment: Alignment.center,
              child: Text(
                NavisLocalizations.of(context).baroInventory,
                style: const TextStyle(fontSize: 17.0, color: Colors.white),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0);
    final localizations = NavisLocalizations.of(context);
    final materialLocale = MaterialLocalizations.of(context);

    final formattedDate = materialLocale
        .formatFullDate(trader.active ? trader.expiry : trader.activation);

    return CustomCard(
      title: localizations.baroTitle,
      child: Column(children: <Widget>[
        RowItem(
          text: Text(trader.active
              ? localizations.baroArriving
              : localizations.baroLeaving),
          padding: padding,
          child: CountdownTimer(
            expiry: trader.active ? trader.expiry : trader.activation,
          ),
        ),
        if (trader.active)
          RowItem(
            text: Text(localizations.baroLocation),
            padding: padding,
            child: StaticBox.text(
              text: '${trader.location}',
              color: primary,
            ),
          ),
        RowItem(
          text: Text(
            trader.active
                ? localizations.baroLeavesOn
                : localizations.baroArrivesOn,
          ),
          padding: padding,
          child: StaticBox.text(
            color: primary,
            text: formattedDate,
          ),
        ),
        const SizedBox(height: 2.0),
        if (trader.active) _buildButton(context, trader.inventory)
      ]),
    );
  }
}