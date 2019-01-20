import 'package:flutter/material.dart';

import 'package:navis/blocs/provider.dart';
import 'package:navis/blocs/worldstate_bloc.dart';
import 'package:navis/models/export.dart';
import 'package:navis/ui/widgets/cards.dart';
import 'package:navis/ui/routes/maps/map.dart';
import 'package:navis/ui/routes/syndicates/syndicate_missions.dart';

class Syndicate extends StatelessWidget {
  final Syndicates syndicate;
  final List<Events> events;

  Syndicate({this.syndicate, this.events});

  final style = TextStyle(color: Colors.white);
  final ostronsColor = Color.fromRGBO(183, 70, 36, 1.0);
  final solarisColor = Color.fromRGBO(206, 162, 54, 1.0);

  @override
  Widget build(BuildContext context) {
    final factionutils = BlocProvider.of<WorldstateBloc>(context).factionUtils;
    bool ostron = syndicate.syndicate == 'Ostrons';

    return Tiles(
      color: ostron ? ostronsColor : solarisColor,
      child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: factionutils.factionIcon(syndicate.syndicate, size: 60),
          title: Text(syndicate.syndicate, style: style),
          subtitle: Text('Tap to see bounties'),
          trailing: IconButton(
              icon: Icon(Icons.map, color: Colors.white),
              onPressed: () => _navigateToMap(context, syndicate.syndicate)),
          onTap: () => _navigateToBounties(context, syndicate, events)),
    );
  }
}

void _navigateToMap(BuildContext context, String syndicate) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Maps(location: _locaton(syndicate))));
}

void _navigateToBounties(
    BuildContext context, Syndicates syn, List<Events> events) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SyndicateJobs(
            faction: _faction(syn.syndicate),
            events: events,
          )));
}

_locaton(String syndicateName) {
  switch (syndicateName) {
    case 'Ostrons':
      return Location.plains;
    default:
      return Location.vallis;
  }
}

_faction(String faction) {
  switch (faction) {
    case 'Ostrons':
      return OpenWorldFactions.cetus;
    case 'Solaris United':
      return OpenWorldFactions.fortuna;
  }
}
