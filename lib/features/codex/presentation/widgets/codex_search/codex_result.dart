import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:navis/core/utils/helper_methods.dart';
import 'package:warframestat_api_models/entities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../pages/codex_entry.dart';
import '../codex_entry/mod_entry.dart';

class CodexResult extends StatelessWidget {
  const CodexResult({Key key, @required this.item}) : super(key: key);

  final BaseItem item;

  Widget _modBuider() {
    final mod = item as Mod;

    String stats;

    if (mod.levelStats != null) {
      stats = mod.levelStats.last['stats'].fold('',
          (String previousValue, element) {
        if (previousValue.isEmpty) {
          return '$element\n';
        } else {
          return '$previousValue$element\n';
        }
      });
    }

    stats = parseHtmlString(stats ?? item.description ?? '');

    switch (mod.rarity) {
      case 'Rare':
        return ModFrame.rare(
          image: mod.imageUrl,
          name: mod.name,
          stats: stats,
          compatName: mod.compatName,
        );
      case 'Uncommon':
        return ModFrame.uncommon(
          image: mod.imageUrl,
          name: mod.name,
          stats: stats,
          compatName: mod.compatName,
        );
      case 'Legendary':
        return ModFrame.primed(
          image: mod.imageUrl,
          name: mod.name,
          stats: stats,
          compatName: mod.compatName,
        );
      default:
        return ModFrame.common(
          image: mod.imageUrl,
          name: mod.name,
          stats: stats,
          compatName: mod.compatName,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImageProvider(item.imageUrl);

    String description;

    if (item is Mod) {
      if ((item as Mod).levelStats != null) {
        description = (item as Mod).levelStats.last['stats'].fold('',
            (String previousValue, element) {
          if (previousValue == null) {
            return '$element ';
          } else {
            return '$previousValue $element ';
          }
        });
      }

      if (description != null) {
        description = parseHtmlString(description);
      }
    }

    return CustomCard(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: image,
          backgroundColor: Theme.of(context)?.canvasColor,
        ),
        title: Text(item.name),
        subtitle: Text(
            description?.trim() ?? parseHtmlString(item.description ?? '')),
        isThreeLine: true,
        dense: true,
        onTap: () {
          if (item is Mod) {
            showDialog<void>(
              context: context,
              child: _modBuider(),
            );
          } else {
            Navigator.of(context)?.pushNamed(CodexEntry.route, arguments: item);
          }
        },
      ),
    );
  }
}