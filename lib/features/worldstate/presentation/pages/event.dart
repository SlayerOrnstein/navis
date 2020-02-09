import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:navis/features/worldstate/data/datasources/event_info_parser.dart';
import 'package:navis/features/worldstate/presentation/widgets/event/guide_player.dart';
import 'package:navis/features/worldstate/presentation/widgets/event/status.dart';
import 'package:navis/injection_container.dart';
import 'package:worldstate_api_model/worldstate_models.dart';

class EventInformation extends StatelessWidget {
  const EventInformation({Key key}) : super(key: key);

  static const route = 'event_information';

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context).settings.arguments as Event;
    final eventInfo = sl<EventInfoParser>().eventInfo[event.description];
    final eventGuide = eventInfo.howTos.first;

    // TODO: Make sure this setup works for all events
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 150.0,
            backgroundColor: Theme.of(context).canvasColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(event.description),
              background: CachedNetworkImage(
                imageUrl: eventInfo.keyArt,
                fit: BoxFit.cover,
                color: const Color.fromRGBO(34, 34, 34, .4),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(<Widget>[
              EventStatus(
                description: event.description,
                tooltip: event.tooltip,
                node: event.victimNode ?? event.node,
                health: event.eventHealth,
                expiry: event.expiry,
                rewards: event.eventRewards,
              ),
              EventVideoPlayer(
                id: eventGuide.id,
                title: eventGuide.title,
                author: eventGuide.author,
                profileThumbnail: eventGuide.pThumbnail,
                link: eventGuide.link,
              )
            ]),
          ),
        ]),
      ),
    );
  }
}
