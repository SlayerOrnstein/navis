import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wfcd_client/entities.dart';

import '../../../../../core/utils/helper_methods.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../pages/codex_entry.dart';
import '../codex_entry/mod_entry.dart';

class CodexResult extends StatelessWidget {
  const CodexResult({Key? key, required this.item}) : super(key: key);

  final Item item;

  Widget _modBuider() {
    final mod = item as Mod;

    String? stats;

    if (mod.levelStats != null) {
      stats = mod.levelStats?.last['stats']!.fold('', (p, e) {
        if (p?.isEmpty ?? true) {
          return '$e\n';
        } else {
          return '$p$e\n';
        }
      });
    }

    stats =
        stats?.parseHtmlString() ?? item.description?.parseHtmlString() ?? '';

    switch (mod.rarity) {
      case 'Rare':
        return ModFrame.rare(
          image: mod.imageUrl,
          name: mod.name,
          stats: stats,
          compatName: mod.compatName ?? '',
          maxRank: mod.fusionLimit,
          baseDrain: mod.baseDrain,
          polarity: mod.polarity,
          rarity: mod.rarity,
          wikiaUrl: mod.wikiaUrl,
        );
      case 'Uncommon':
        return ModFrame.uncommon(
          image: mod.imageUrl,
          name: mod.name,
          stats: stats,
          compatName: mod.compatName ?? '',
          maxRank: mod.fusionLimit,
          baseDrain: mod.baseDrain,
          polarity: mod.polarity,
          rarity: mod.rarity,
          wikiaUrl: mod.wikiaUrl,
        );
      case 'Legendary':
        return ModFrame.primed(
          image: mod.imageUrl,
          name: mod.name,
          stats: stats,
          compatName: mod.compatName ?? '',
          maxRank: mod.fusionLimit,
          baseDrain: mod.baseDrain,
          polarity: mod.polarity,
          rarity: mod.rarity,
          wikiaUrl: mod.wikiaUrl,
        );
      default:
        return ModFrame.common(
          image: mod.imageUrl,
          name: mod.name,
          stats: stats,
          compatName: mod.compatName ?? '',
          maxRank: mod.fusionLimit,
          baseDrain: mod.baseDrain,
          polarity: mod.polarity,
          rarity: mod.rarity,
          wikiaUrl: mod.wikiaUrl,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? description;

    if (item is Mod) {
      if ((item as Mod).levelStats != null) {
        description = (item as Mod).levelStats?.last['stats']!.fold('', (p, e) {
          if (p == null) {
            return '$e ';
          } else {
            return '$p $e ';
          }
        });
      }

      if (description != null) {
        description = description.parseHtmlString();
      }
    }

    return CustomCard(
      child: ListTile(
        leading: Hero(
          tag: item.uniqueName,
          child: CircleAvatar(
            backgroundImage: item.imageName != null
                ? CachedNetworkImageProvider(item.imageUrl)
                : null,
            backgroundColor: Theme.of(context).canvasColor,
          ),
        ),
        title: Text(item.name),
        subtitle: Text(
            description?.trim() ?? item.description?.parseHtmlString() ?? ''),
        isThreeLine: true,
        dense: true,
        onTap: () {
          if (item is Mod) {
            showDialog<void>(
              context: context,
              builder: (context) => _modBuider(),
            );
          } else {
            Navigator.of(context).pushNamed(CodexEntry.route, arguments: item);
          }
        },
      ),
    );
  }
}
