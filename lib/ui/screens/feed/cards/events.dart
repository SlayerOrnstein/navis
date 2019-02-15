import 'package:flutter/material.dart';
import 'package:navis/models/export.dart';
import 'package:navis/ui/widgets/static_box.dart';
import 'package:navis/ui/routes/syndicates/rewards.dart';

class Event extends StatelessWidget {
  const Event({this.event});

  final Events event;

  Color _healthColor(double health) {
    if (health > 50.0)
      return Colors.green;
    else if (health <= 50.0 && health >= 10.0)
      return Colors.orange[700];
    else
      return Colors.red;
  }

  void _addReward(BuildContext context, bool bounty, List<Widget> children) {
    if (bounty) {
      children.addAll(event.jobs.map((j) => _buildJob(context, j)));
    } else {
      if (event.rewards.isNotEmpty) {
        children.add(StaticBox.text(
            color: Colors.green,
            text:
                '${event.rewards.first.itemString} + ${event.rewards.first.credits}cr'));
      }

      children.add(Container());
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    final victimNode = event.victimNode == null
        ? Container()
        : StaticBox.text(text: event.victimNode, color: Colors.red);

    final progress = event.health == null
        ? Container()
        : StaticBox.text(
            text: '${event.health}% Remaining',
            color: _healthColor(double.parse(event.health)),
          );

    _addReward(context, event.jobs?.isNotEmpty ?? false, children);

    return SizedBox(
        height: 140,
        width: MediaQuery.of(context).size.width,
        child: Material(
            color: Theme.of(context).cardColor,
            elevation: 6,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(bottom: 4, top: 3),
                      child: Text(event.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title)),
                  event.tooltip == null
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Text(event.tooltip,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        victimNode,
                        const SizedBox(width: 4),
                        progress
                      ]),
                  const SizedBox(height: 4),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children)
                ])));
  }
}

Widget _buildJob(BuildContext context, Jobs job) {
  return Card(
    margin: const EdgeInsets.only(right: 3.0),
    color: Colors.blueAccent[400],
    child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BountyRewards(
                missionTYpe: job.type,
                bountyRewards: job.rewardPool.cast<String>()))),
        child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            child: Text(job.type,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(fontSize: 13, color: Colors.white)))),
  );
}
