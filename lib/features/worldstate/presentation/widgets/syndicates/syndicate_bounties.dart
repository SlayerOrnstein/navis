import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:worldstate_api_model/entities.dart';

import '../../../utils/faction_utils.dart';
import 'syndicate_bounty_header.dart';

class SyndicateBounties extends StatelessWidget {
  const SyndicateBounties({Key key, @required this.syndicate})
      : super(key: key);

  final Syndicate syndicate;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        for (Job job in syndicate?.jobs ?? [])
          SliverStickyHeader(
            header: SyndicateBountyHeader(
              job: job,
              faction: syndicateStringToEnum(syndicate.id),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(title: Text(job.rewardPool[index]));
                },
                childCount: job.rewardPool.length,
              ),
            ),
          )
      ],
    );
  }
}