import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wfcd_client/wfcd_client.dart';

import 'core/cubits/navigation_cubit.dart';
import 'core/local/user_settings.dart';
import 'core/network/network_info.dart';
import 'core/notifiers/user_settings_notifier.dart';
import 'core/services/notifications.dart';
import 'core/services/videos.dart';
import 'features/codex/data/datasources/market_cache.dart';
import 'features/codex/data/repositories/codex_repository_impl.dart';
import 'features/codex/data/repositories/market_repository_impl.dart';
import 'features/codex/domian/repositories/codex_repository.dart';
import 'features/codex/domian/repositories/market_repository.dart';
import 'features/codex/domian/usercases/get_orders.dart';
import 'features/codex/domian/usercases/search_items.dart';
import 'features/codex/presentation/bloc/market_bloc.dart';
import 'features/codex/presentation/bloc/search_bloc.dart';
import 'features/synthtargets/data/repositories/synth_target_rep_impl.dart';
import 'features/synthtargets/domain/repositories/synth_target_repository.dart';
import 'features/synthtargets/domain/usecases/get_synth_targets.dart';
import 'features/synthtargets/presentation/bloc/synthtargets_bloc.dart';
import 'features/worldstate/data/datasources/event_info_parser.dart';
import 'features/worldstate/data/datasources/warframestate_local.dart';
import 'features/worldstate/data/repositories/worldstate_rep_impl.dart';
import 'features/worldstate/domain/repositories/worldstate_repository.dart';
import 'features/worldstate/domain/usecases/get_darvo_deal_info.dart';
import 'features/worldstate/domain/usecases/get_worldstate.dart';
import 'features/worldstate/presentation/bloc/darvodeal_bloc.dart';
import 'features/worldstate/presentation/bloc/solsystem_bloc.dart';

final GetIt sl = GetIt.instance;

bool _isDebug = false;

Future<void> init() async {
  final temp = await getTemporaryDirectory();
  final appDir = await getApplicationDocumentsDirectory();

  Hive..init(appDir.path)..init(temp.path);

  assert(_isDebug = true);
  // Core
  sl
    ..registerSingleton<NetworkInfo>(
        NetworkInfoImpl(InternetConnectionChecker()))
    ..registerSingletonAsync<EventInfoParser>(EventInfoParser.loadEventData)
    ..registerSingleton<VideoService>(VideoService())
    ..registerSingletonAsync<PackageInfo>(PackageInfo.fromPlatform)
    ..registerSingleton<NotificationService>(
        _isDebug ? NotificationServiceDebug() : NotificationServiceRelease())

    // Data sources
    ..registerSingletonAsync(Usersettings.initUsersettings)
    ..registerSingleton<WarframestatClient>(WarframestatClient())
    ..registerSingletonAsync<WarframestatCache>(WarframestatCache.initCache)
    ..registerSingletonAsync(MarketCache.initCache);

  await sl.isReady<Usersettings>();
  await sl.isReady<WarframestatCache>();
  await sl.isReady<MarketCache>();

  // Repository
  sl
    ..registerSingleton<UserSettingsNotifier>(UserSettingsNotifier(
      sl<Usersettings>(),
    ))
    ..registerSingleton<WorldstateRepository>(
      WorldstateRepositoryImpl(
        sl<NetworkInfo>(),
        sl<WarframestatCache>(),
        sl<Usersettings>(),
      ),
    )
    ..registerSingleton<SynthRepository>(SynthRepositoryImpl(sl<NetworkInfo>()))
    ..registerSingleton<CodexRepository>(CodexRepositoryImpl(sl<NetworkInfo>()))
    ..registerSingleton<MarketRepository>(MarketRepositoryImpl(
        sl<NetworkInfo>(), sl<Usersettings>(), sl<MarketCache>()))

    // Usecases
    ..registerSingleton<GetWorldstate>(
        GetWorldstate(sl<WorldstateRepository>()))
    ..registerSingleton<GetDarvoDealInfo>(
        GetDarvoDealInfo(sl<WorldstateRepository>()))
    ..registerSingleton<GetSynthTargets>(GetSynthTargets(sl<SynthRepository>()))
    ..registerSingleton<SearchItems>(SearchItems(sl<CodexRepository>()))
    ..registerSingleton<GetOrders>(GetOrders(sl<MarketRepository>()))

    // Blocs
    ..registerFactory<NavigationCubit>(() => NavigationCubit())
    ..registerFactory<SolsystemBloc>(() {
      return SolsystemBloc(getWorldstate: sl<GetWorldstate>());
    })
    ..registerFactory<DarvodealBloc>(() {
      return DarvodealBloc(getDarvoDealInfo: sl<GetDarvoDealInfo>());
    })
    ..registerFactory(() => SynthtargetsBloc(sl<GetSynthTargets>()))
    ..registerFactory<SearchBloc>(() => SearchBloc(sl<SearchItems>()))
    ..registerFactory(() => MarketBloc(sl<GetOrders>()));
}
