import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navis/services/repository.dart';
import 'package:navis/utils/size_config.dart';
import 'package:navis/utils/utils.dart';
import 'package:navis/widgets/animations/countdown.dart';
import 'package:navis/widgets/widgets.dart';
import 'package:warframe_items_model/warframe_items_model.dart';
import 'package:worldstate_model/worldstate_models.dart';

class DealWidget extends StatefulWidget {
  const DealWidget({Key key, this.deal}) : super(key: key);

  final DarvoDeal deal;

  @override
  _DealWidgetState createState() => _DealWidgetState();
}

class _DealWidgetState extends State<DealWidget>
    with AutomaticKeepAliveClientMixin {
  final AsyncMemoizer<ItemObject> _itemFuture = AsyncMemoizer();

  Future<ItemObject> _getItem() async {
    final api = RepositoryProvider.of<Repository>(context).worldstateService;

    return _itemFuture?.runOnce(() async {
      return await api.getDeal(widget.deal);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final fontSize = SizeConfig.widthMultiplier * 3.5;
    final style = Theme.of(context)
        .textTheme
        .caption
        .copyWith(fontSize: fontSize, fontWeight: FontWeight.bold);

    final primary = Theme.of(context).primaryColor;

    return FutureBuilder<ItemObject>(
      future: _getItem(),
      builder: (BuildContext context, AsyncSnapshot<ItemObject> snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final item = snapshot.data;

        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                DealImage(
                  imageUrl: item.imageUrl,
                  wikiaUrl: item?.wikiaUrl,
                ),
                const SizedBox(width: 16.0),
                DealDetails(
                  itemName: item.name,
                  itemDescription: parseHtmlString(item.description),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StaticBox.text(
                  text: '${widget.deal.discount}% Discount',
                  color: primary,
                  style: style,
                ),
                // TODO(Orn): should probably put a plat icon here instead
                StaticBox.text(
                  text: '${widget.deal.salePrice}\p',
                  color: primary,
                  style: style,
                ),
                StaticBox.text(
                  text:
                      '${widget.deal.total - widget.deal.sold} / ${widget.deal.total} remaining',
                  color: primary,
                  style: style,
                ),
                CountdownBox(expiry: widget.deal.expiry, style: style),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DealDetails extends StatelessWidget {
  const DealDetails({
    Key key,
    this.itemName,
    this.itemDescription,
    this.wikiaUrl,
    this.itemInfo,
  }) : super(key: key);

  final String itemName, itemDescription, wikiaUrl;
  final Widget itemInfo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          itemName,
          style: textTheme.subhead
              .copyWith(fontSize: SizeConfig.textMultiplier * 2.3),
        ),
        const SizedBox(height: 8.0),
        Container(
          height: SizeConfig.heightMultiplier * 15,
          width: SizeConfig.widthMultiplier * 40,
          child: Text(
            itemDescription,
            maxLines: 7,
            overflow: TextOverflow.ellipsis,
            style: textTheme.caption
                .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
          ),
        ),
        itemInfo ?? Container()
      ],
    );
  }
}

class DealImage extends StatelessWidget {
  const DealImage({
    Key key,
    @required this.imageUrl,
    this.wikiaUrl,
  })  : assert(imageUrl != null),
        super(key: key);

  final String imageUrl;
  final String wikiaUrl;

  Widget _placeholder(BuildContext context, String url) {
    final width = SizeConfig.widthMultiplier * 40;

    return LimitedBox(
      maxWidth: width,
      child: Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _errorWidget(BuildContext context, String url, Object error) {
    return const NavisErrorWidget(
      title: 'Item not found by API',
      description:
          'Sorry but it seems the item hasn\'t been added to the API yet.',
      showStacktrace: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = SizeConfig.widthMultiplier * 40;

    final image = LimitedBox(
      maxWidth: width,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: _placeholder,
        errorWidget: _errorWidget,
      ),
    );

    if (wikiaUrl == null) return image;

    return InkWell(
      onTap: () => launchLink(context, wikiaUrl),
      child: image,
    );
  }
}
