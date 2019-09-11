import 'package:flutter/material.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/widgets/screen_widgets/syndicates/syndicates.dart';
import 'package:navis/widgets/widgets.dart';

import 'package:worldstate_model/worldstate_models.dart';

class SyndicatesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WorldstateBloc bloc = BlocProvider.of<WorldstateBloc>(context);

    return RefreshIndicator(
        onRefresh: () => bloc.update(),
        child: BlocBuilder(
            bloc: bloc,
            builder: (context, state) {
              if (state is WorldstateLoaded) {
                final List<Syndicate> syndicates =
                    state.worldstate?.syndicateMissions ?? [];

                final Nightwave nightwave = state.worldstate?.nightwave;

                return ListView(children: <Widget>[
                  if (syndicates.isNotEmpty)
                    TimerBox(
                      title: 'Bounties expire in:',
                      time: syndicates.first.expiry,
                    ),
                  Column(children: <Widget>[
                    ...syndicates
                        .map((Syndicate syn) => SyndicateWidget(syndicate: syn))
                  ]),
                  const SizedBox(height: 20),
                  if (nightwave != null) ...{
                    TimerBox(
                      title: 'Season ends in:',
                      time: nightwave?.expiry ?? DateTime.now(),
                    ),
                    NightWaveWidget(season: nightwave.season)
                  },
                ]);
              }

              return const Center(child: CircularProgressIndicator());
            }));
  }
}