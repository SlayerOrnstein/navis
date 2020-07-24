import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:navis/core/utils/ui_util.dart';
import 'package:navis/core/widgets/custom_card.dart';
import 'package:navis/core/widgets/responsive_builder.dart';
import 'package:warframestat_api_models/entities.dart';

class CodexResult extends StatelessWidget {
  const CodexResult({Key key, this.item}) : super(key: key);

  final BaseItem item;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizeInfo) {
        return CustomCard(
          child: Container(
            height: sizeInfo.heightMultiplier * 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: ItemContent(
                    name: item.name,
                    description: item.description ?? '',
                    imageUrl: item.imageUrl,
                  ),
                ),
                // const Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CircleAvatar(
                      radius: sizeInfo.widthMultiplier * 12,
                      backgroundColor: Theme.of(context).cardTheme.color,
                      backgroundImage:
                          CachedNetworkImageProvider(item.imageUrl),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemContent extends StatelessWidget {
  const ItemContent({
    Key key,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
  })  : assert(name != null),
        assert(description != null),
        assert(imageUrl != null),
        super(key: key);

  final String name, description, imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizeInfo) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                name,
                style: textTheme.subtitle1,
              ),
              const SizedBox(height: 12),
              Container(
                width: sizeInfo.widthMultiplier * 60,
                child: Text(
                  description,
                  style: textTheme.caption,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}