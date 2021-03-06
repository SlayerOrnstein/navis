import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wfcd_client/entities.dart';

import '../../../../../core/utils/helper_methods.dart';
import '../../../../../core/widgets/widgets.dart';

class PatchlogCard extends StatelessWidget {
  const PatchlogCard({Key? key, required this.patchlog}) : super(key: key);

  final Patchlog patchlog;

  static const _backupImage = 'https://i.imgur.com/CNrsc7V.png';

  Widget _log(BuildContext context, String log) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        log.splitMapJoin('\n', onMatch: (m) => '\n\n', onNonMatch: (n) => n),
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 95,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      patchlog.imgUrl ?? _backupImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(.6), BlendMode.darken),
                ),
              ),
              child: CategoryTitle(
                title: patchlog.name,
                subtitle: patchlog.date.format(context),
              ),
            ),
            if (patchlog.additions.isNotEmpty) ...{
              const CategoryTitle(title: 'Additions'),
              _log(context, patchlog.additions)
            },
            if (patchlog.changes.isNotEmpty) ...{
              const CategoryTitle(title: 'Changes'),
              _log(context, patchlog.changes)
            },
            if (patchlog.fixes.isNotEmpty) ...{
              const CategoryTitle(title: 'Fixes'),
              _log(context, patchlog.fixes)
            },
            const Spacer(),
            ButtonBar(
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () => patchlog.url.launchLink(context),
                  child: const Text('FULL PATCH NOTES'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
