import 'package:market_client/market_client.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../core/error/failures.dart';

abstract class MarketRepository {
  const MarketRepository();

  Future<Result<List<ItemOrder>, Failure>> retriveOrders(String itemName);
}
