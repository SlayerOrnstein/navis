import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:wfcd_client/wfcd_client.dart';

import 'core/bloc/navigation_bloc.dart';
import 'core/local/user_settings.dart';
import 'core/network/network_info.dart';
import 'core/services/notifications.dart';
import 'core/services/videos.dart';
import 'features/codex/data/repositories/codex_repository_impl.dart';
import 'features/codex/domian/repositories/codex_repository.dart';
import 'features/codex/domian/usercases/search_items.dart';
import 'features/codex/presentation/bloc/search_bloc.dart';
import 'features/synthtargets/data/repositories/synth_target_rep_impl.dart';
import 'features/synthtargets/domain/repositories/synth_target_repository.dart';
import 'features/synthtargets/domain/usecases/get_synth_targets.dart';
import 'features/synthtargets/presentation/bloc/synthtargets_bloc.dart';
import 'features/worldstate/data/datasources/event_info_parser.dart';
import 'features/worldstate/data/datasources/skybox_parser.dart';
import 'features/worldstate/data/datasources/warframestate_local.dart';
import 'features/worldstate/data/repositories/worldstate_rep_impl.dart';
import 'features/worldstate/domain/repositories/worldstate_repository.dart';
import 'features/worldstate/domain/usecases/get_darvo_deal_info.dart';
import 'features/worldstate/domain/usecases/get_worldstate.dart';
import 'features/worldstate/presentation/bloc/solsystem_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_nightmare');
  const initializationSettingsIOS = IOSInitializationSettings();
  const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Core
  sl.registerSingleton<FlutterLocalNotificationsPlugin>(
      flutterLocalNotificationsPlugin);

  sl.registerSingleton<NetworkInfo>(NetworkInfoImpl(DataConnectionChecker()));

  sl.registerSingletonAsync<EventInfoParser>(
    () => EventInfoParser.loadEventData(),
  );

  sl.registerSingleton<VideoService>(VideoService());

  sl.registerSingletonAsync<PackageInfo>(() => PackageInfo.fromPlatform());
  sl.registerSingleton<NotificationService>(
      NotificationService(FirebaseMessaging()));

  // Data sources
  sl.registerSingleton<WarframestatClient>(WarframestatClient());

  sl.registerSingletonAsync(() => Usersettings.initUsersettings());

  sl.registerSingletonAsync<WarframestatCache>(
    () => WarframestatCache.initCache(),
  );

  sl.registerSingletonAsync<SkyboxService>(
      () async => SkyboxService.loadSkyboxData());

  await sl.isReady<WarframestatCache>();
  await sl.isReady<Usersettings>();

  // Repository
  sl.registerSingleton<WorldstateRepository>(
    WorldstateRepositoryImpl(
      sl<NetworkInfo>(),
      sl<WarframestatCache>(),
      sl<Usersettings>(),
    ),
  );
  sl.registerSingleton<SynthRepository>(
    SynthRepositoryImpl(sl<NetworkInfo>()),
  );
  sl.registerSingleton<CodexRepository>(CodexRepositoryImpl(sl<NetworkInfo>()));

  // Usecases
  sl.registerSingleton<GetWorldstate>(
    GetWorldstate(sl<WorldstateRepository>()),
  );
  sl.registerSingleton<GetDarvoDealInfo>(
    GetDarvoDealInfo(sl<WorldstateRepository>()),
  );
  sl.registerSingleton<GetSynthTargets>(
    GetSynthTargets(sl<SynthRepository>()),
  );
  sl.registerSingleton<SearchItems>(SearchItems(sl<CodexRepository>()));

  // Blocs
  sl.registerFactory<NavigationBloc>(() => NavigationBloc());
  sl.registerFactory<SolsystemBloc>(() {
    return SolsystemBloc(
      getWorldstate: sl<GetWorldstate>(),
      getDarvoDealInfo: sl<GetDarvoDealInfo>(),
    );
  });

  sl.registerFactory(() => SynthtargetsBloc(sl<GetSynthTargets>()));

  sl.registerFactory<SearchBloc>(() => SearchBloc(sl<SearchItems>()));
}
