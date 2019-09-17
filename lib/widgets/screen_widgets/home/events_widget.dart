import 'package:flutter/material.dart';
import 'package:navis/widgets/animations.dart';
import 'package:navis/widgets/widgets.dart';
import 'package:worldstate_model/worldstate_models.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 4),
          _EventHeader(
            description: event.description,
            tooltip: event.tooltip,
          ),
          const SizedBox(height: 4),
          _EventMiddle(
            victimNode: event.victimNode,
            health: event.eventHealth,
            rewards: event.rewards,
            expiry: event.expiry,
          ),
          const SizedBox(height: 8),
          _EventFooter(
            affiliatedWith: event.affiliatedWith,
            rewards: event.eventRewards,
            jobs: event?.jobs,
          )
        ]);
  }
}

class _EventHeader extends StatelessWidget {
  const _EventHeader({
    Key key,
    @required this.description,
    @required this.tooltip,
  }) : super(key: key);

  final String description, tooltip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 4, top: 3),
          child: Text(description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title),
        ),
        if (tooltip != null)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Text(tooltip,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle),
          )
      ],
    );
  }
}

class _EventMiddle extends StatelessWidget {
  const _EventMiddle({
    Key key,
    @required this.victimNode,
    @required this.health,
    @required this.rewards,
    @required this.expiry,
  }) : super(key: key);

  final String victimNode;
  final double health;
  final List<Reward> rewards;
  final DateTime expiry;

  Color _healthColor(double health) {
    if (health > 50.0)
      return Colors.green;
    else if (health <= 50.0 && health >= 10.0)
      return Colors.orange[700];
    else
      return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      if (victimNode != null)
        StaticBox.text(text: victimNode, color: Colors.red),
      if (rewards.where((r) => r.credits > 0).isNotEmpty)
        StaticBox.text(
          text: '${rewards.firstWhere((r) => r.credits > 0).credits}cr',
          color: Theme.of(context).primaryColor,
        ),
      const SizedBox(height: 4),
      if (health != null)
        StaticBox.text(
          text: '${health.toStringAsFixed(2)}% remaining',
          color: _healthColor(health),
        )
      else
        CountdownBox(expiry: expiry),
    ]);
  }
}

class _EventFooter extends StatelessWidget {
  const _EventFooter({
    Key key,
    @required this.affiliatedWith,
    @required this.rewards,
    @required this.jobs,
  }) : super(key: key);

  final String affiliatedWith;
  final List<String> rewards;
  final List<Job> jobs;

  Widget _addReward() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        for (String r in rewards) StaticBox.text(color: Colors.green, text: r)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (jobs?.isNotEmpty ?? false) {
      return FlatButton(
        child: const Text('See Bounties'),
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: () {
          final syndicate = Syndicate(name: affiliatedWith, jobs: jobs);

          Navigator.of(context)
              .pushNamed('/syndicate_jobs', arguments: syndicate);
        },
      );
    } else {
      return _addReward();
    }
  }
}
