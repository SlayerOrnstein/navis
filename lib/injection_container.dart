import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:navis/features/worldstate/presentation/bloc/solsystem_bloc.dart';

import 'core/bloc/navigation_bloc.dart';
import 'core/data/datasources/warframestat_local.dart';
import 'core/data/datasources/warframestat_remote.dart';
import 'core/data/repositories/warframestat_repository_impl.dart';
import 'core/network/network_info.dart';
import 'features/worldstate/data/datasources/event_info_parser.dart';
import 'features/worldstate/domain/usecases/get_darvo_deal_info.dart';
import 'features/worldstate/domain/usecases/get_synth_targets.dart';
import 'features/worldstate/domain/usecases/get_worldstate.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerSingleton<NetworkInfoImpl>(
      NetworkInfoImpl(DataConnectionChecker()));

  sl.registerSingleton<EventInfoParser>(await EventInfoParser.loadEventData());

  // Data sources
  sl.registerSingleton<WarframestatRemote>(WarframestatRemote(http.Client()));

  sl.registerSingleton<WarframestatCache>(
      await WarframestatCache.getInstance());

  // Repository
  sl.registerSingleton<WarframestatRepositoryImpl>(
    WarframestatRepositoryImpl(
      local: sl<WarframestatCache>(),
      remote: sl<WarframestatRemote>(),
      networkInfo: sl<NetworkInfoImpl>(),
    ),
  );

  // Usecases
  sl.registerSingleton<GetWorldstate>(
      GetWorldstate(sl<WarframestatRepositoryImpl>()));
  sl.registerSingleton<GetDarvoDealInfo>(
      GetDarvoDealInfo(sl<WarframestatRepositoryImpl>()));
  sl.registerSingleton<GetSynthTargets>(
      GetSynthTargets(sl<WarframestatRepositoryImpl>()));

  // Blocs
  sl.registerFactory<NavigationBloc>(() => NavigationBloc());
  sl.registerFactory<SolsystemBloc>(() {
    return SolsystemBloc(
      getWorldstate: sl<GetWorldstate>(),
      getDarvoDealInfo: sl<GetDarvoDealInfo>(),
      getSynthTargets: sl<GetSynthTargets>(),
    );
  });
}
