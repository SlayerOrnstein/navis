import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wfcd_client/entities.dart';

import '../../../../core/utils/helper_methods.dart';
import '../../../../injection_container.dart';
import '../bloc/market_bloc.dart';
import '../widgets/codex_widgets.dart';
import '../widgets/market/market_order.dart';

class CodexEntry extends StatelessWidget {
  const CodexEntry({Key? key}) : super(key: key);

  static const route = '/codexEntry';

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)?.settings.arguments as Item;
    final heightRatio = MediaQuery.of(context).size.height / 100;
    final height = heightRatio * 30;

    return Scaffold(
      body: SafeArea(
        child: item.patchlogs != null
            ? TabbedEntry(item: item, height: height)
            : SingleEntry(item: item, height: height),
      ),
    );
  }
}

class SingleEntry extends StatelessWidget {
  const SingleEntry({
    Key? key,
    required this.item,
    required this.height,
  }) : super(key: key);

  final Item item;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: BasicItemInfo(
            uniqueName: item.uniqueName,
            name: item.name,
            description: item.description?.parseHtmlString() ?? '',
            wikiaUrl: item.wikiaUrl,
            imageUrl: item.imageUrl,
            expandedHeight: height,
          ),
        ),
        SliverFillRemaining(
          child: Overview(item: item),
        )
      ],
    );
  }
}

class TabbedEntry extends StatelessWidget {
  const TabbedEntry({
    Key? key,
    required this.item,
    required this.height,
  }) : super(key: key);

  final Item item;
  final double height;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const Tab(text: 'Overview'),
      if (item.patchlogs != null || item.patchlogs!.isNotEmpty)
        const Tab(text: 'Patchlogs'),
      if (item.tradable) const Tab(text: 'Market')
    ];

    return DefaultTabController(
      length: tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (context, index) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: BasicItemInfo(
                uniqueName: item.uniqueName,
                name: item.name,
                description: item.description?.parseHtmlString() ?? '',
                wikiaUrl: item.wikiaUrl,
                imageUrl: item.imageUrl,
                bottom: TabBar(
                  labelColor: Theme.of(context).textTheme.bodyText1?.color,
                  indicatorColor: Theme.of(context).textTheme.bodyText1?.color,
                  tabs: tabs,
                ),
                expandedHeight: height + kTextTabBarHeight,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            Overview(item: item),
            if (item.patchlogs != null || item.patchlogs!.isNotEmpty)
              PatchlogsTimeline(patchlogs: item.patchlogs ?? []),
            if (item.tradable)
              Market(
                itemName: item.name,
              )
          ],
        ),
      ),
    );
  }
}

class Overview extends StatelessWidget {
  const Overview({Key? key, required this.item}) : super(key: key);

  final Item item;

  bool get _isPowerSuit => item is PowerSuit;
  bool get _isGun => item is ProjectileWeapon && item.category != 'Pets';
  bool get _isMeleeWeapon => item is MeleeWeapon;
  bool get _isFoundryItem {
    return item is FoundryItem &&
        (item as FoundryItem).components != null &&
        ((item as FoundryItem).components?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('overview'),
      padding: EdgeInsets.zero,
      children: [
        if (_isPowerSuit)
          FrameStats(powerSuit: item as PowerSuit)
        else if (_isGun)
          GunStats(projectileWeapon: item as ProjectileWeapon)
        else if (_isMeleeWeapon)
          MeleeStats(meleeWeapon: item as MeleeWeapon),
        if (_isFoundryItem)
          ItemComponents(
            itemImageUrl: item.imageUrl,
            components: (item as FoundryItem).components!,
          ),
      ],
    );
  }
}

class PatchlogsTimeline extends StatelessWidget {
  const PatchlogsTimeline({Key? key, required this.patchlogs})
      : super(key: key);

  final List<Patchlog> patchlogs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey('patchlogs'),
      padding: EdgeInsets.zero,
      itemCount: patchlogs.length,
      itemBuilder: (_, index) => PatchlogCard(patchlog: patchlogs[index]),
    );
  }
}

class Market extends StatefulWidget {
  const Market({Key? key, required this.itemName}) : super(key: key);

  final String itemName;

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: sl<MarketBloc>()..add(FindOrders(widget.itemName)),
      builder: (context, state) {
        if (state is OrdersFound) {
          final orders = state.orders;

          return ListView.builder(
            key: const PageStorageKey('market'),
            padding: EdgeInsets.zero,
            itemCount: orders.length,
            itemBuilder: (_, index) => MarketSellWidget(order: orders[index]),
          );
        }

        if (state is NoOrdersFound) {
          return const Center(
            child: Text('No seller orders found for this item'),
          );
        }

        if (state is MarketError) {
          return Center(
            child: Text(state.message),
          );
        }

        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
