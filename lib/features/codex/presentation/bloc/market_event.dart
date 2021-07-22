part of 'market_bloc.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

class FindOrders extends MarketEvent {
  const FindOrders(this.item);

  final String item;

  @override
  List<Object?> get props => [item];
}
