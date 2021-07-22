import 'package:market_client/market_client.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/market_repository.dart';

class GetOrders extends Usecase<List<ItemOrder>, String> {
  const GetOrders(this.marketRepository);

  final MarketRepository marketRepository;

  @override
  Future<Result<List<ItemOrder>, Failure>> call(String params) {
    return marketRepository.retriveOrders(params);
  }
}
