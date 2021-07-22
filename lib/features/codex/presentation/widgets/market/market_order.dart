import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:market_client/market_client.dart';
import '../../../../../core/widgets/widgets.dart';

class MarketSellWidget extends StatelessWidget {
  const MarketSellWidget({Key? key, required this.order}) : super(key: key);

  final ItemOrder order;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: _MarketSellLeading(
              avater: order.user.avatar,
              orderType: order.orderType,
              status: order.user.status,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: _MarketSellBody(
                username: order.user.ingameName,
                reputation: order.user.reputation,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 16.0),
            child: _MarketSellTrailing(
              quantity: order.quantity,
              price: order.platinum.toInt(),
            ),
          )
        ],
      ),
    );
  }
}

class _MarketSellLeading extends StatelessWidget {
  const _MarketSellLeading({
    Key? key,
    this.avater,
    required this.orderType,
    required this.status,
  }) : super(key: key);

  final String? avater;
  final OrderType orderType;
  final UserStatus status;

  static const _defaultAvater = 'user/default-avatar.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 22.5,
          backgroundColor: () {
            switch (status) {
              case UserStatus.online:
                return Colors.green;
              case UserStatus.ingame:
                return Colors.purple;
              case UserStatus.offline:
                return Colors.grey[600];
            }
          }(),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            foregroundImage: CachedNetworkImageProvider(
                'https://warframe.market/static/assets/${avater ?? _defaultAvater}'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16.0),
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(4.0)),
          child: Text(
            () {
              switch (orderType) {
                case OrderType.sell:
                  return 'WTS';
                case OrderType.buy:
                  return 'WTB';
              }
            }(),
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class _MarketSellBody extends StatelessWidget {
  const _MarketSellBody({
    Key? key,
    required this.username,
    required this.reputation,
  }) : super(key: key);

  final String username;
  final int reputation;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.subtitle1?.copyWith(fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 2.0, bottom: 2.0),
                child: Icon(Icons.tag_faces, size: 15.0),
              ),
              Text(
                'Reputation $reputation',
                style: textTheme.caption,
              )
            ],
          ),
        )
      ],
    );
  }
}

class _MarketSellTrailing extends StatelessWidget {
  const _MarketSellTrailing({
    Key? key,
    required this.quantity,
    required this.price,
  }) : super(key: key);

  final int quantity, price;

  Widget _buildColumn(TextTheme textTheme, String header, int value) {
    final headerStyle =
        textTheme.caption?.copyWith(fontWeight: FontWeight.w500);
    final valueStyle =
        textTheme.headline5?.copyWith(fontWeight: FontWeight.w800);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(header, style: headerStyle),
        const SizedBox(height: 6.0),
        Text('$value'.padLeft(2, '0'), style: valueStyle)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 65.0,
      child: Row(
        children: [
          _buildColumn(textTheme, 'Quantity', quantity),
          Container(
            width: 20.0,
            height: 2.0,
            margin: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 0),
            color: Theme.of(context).textTheme.bodyText2?.color,
          ),
          _buildColumn(textTheme, 'Platinum', price)
        ],
      ),
    );
  }
}
