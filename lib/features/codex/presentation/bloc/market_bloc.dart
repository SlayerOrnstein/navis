import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:market_client/market_client.dart';

import '../../../../core/error/failures.dart';
import '../../domian/usercases/get_orders.dart';

part 'market_event.dart';
part 'market_state.dart';

class MarketBloc extends HydratedBloc<MarketEvent, MarketState> {
  MarketBloc(this.getOrders) : super(MarketInitial());

  final GetOrders getOrders;

  @override
  Stream<MarketState> mapEventToState(MarketEvent event) async* {
    if (event is FindOrders) {
      yield const FindingOrders();
      final _orders = await getOrders(event.item);

      yield _orders.match(
        (orders) {
          if (orders.isNotEmpty) {
            return OrdersFound(_sortOrders(orders));
          } else {
            return const NoOrdersFound();
          }
        },
        (f) {
          if (f is CacheFailure) {
            return const MarketError('There was a cache error');
          } else if (f is ServerFailure) {
            return const MarketError('Warframe Market returned and error');
          } else {
            return const MarketError('Unknown error occured');
          }
        },
      );
    }
  }

  @override
  MarketState? fromJson(Map<String, dynamic> json) {
    final orders = json['orders'] as List<dynamic>;

    return OrdersFound(
      orders.map((e) => ItemOrder.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(MarketState state) {
    if (state is OrdersFound && state.orders.isNotEmpty) {
      final orders = state.orders.map((e) => e.toJson());

      return {'orders': orders.toList()};
    }

    return null;
  }

  List<ItemOrder> _sortOrders(List<ItemOrder> orders) {
    return orders..sort((a, b) => a.compareTo(b));
  }
}