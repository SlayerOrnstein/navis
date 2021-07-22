part of 'market_bloc.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object> get props => [];
}

class MarketInitial extends MarketState {}

class FindingOrders extends MarketState {
  const FindingOrders();
}

class OrdersFound extends MarketState {
  const OrdersFound(this.orders);

  final List<ItemOrder> orders;
}

class NoOrdersFound extends MarketState {
  const NoOrdersFound();
}

class MarketError extends MarketState {
  const MarketError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
