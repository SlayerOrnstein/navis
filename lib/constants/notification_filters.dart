import 'storage_keys.dart';

const simple = [
  {
    'name': 'Rare Alerts',
    'description': 'Rare alert notifications, mainly gifts of the lotus',
    'key': NotificationKeys.alertsKey
  },
  // {
  //   'name': 'Baro Ki\'Teer Arrival',
  //   'description': 'For when Baro has arrived',
  //   'key': baroKey
  // },
  // {
  //   'name': 'Darvo\'s Daily Deals',
  //   'description': 'Darvo\'s new find of the day',
  //   'key': darvoKey
  // },
  {
    'name': 'Sorties',
    'description': 'Notifications for new sorties',
    'key': NotificationKeys.sortiesKey
  }
];

const filtered = {
  //'News': 'News notifications for Prime Access, Streams and Updates',
  'Cycles': 'Day/Night cycle notifications',
  'Resources': 'Resources mostly found in invasions'
  //'Fissure Missions': 'Filter fissure notifications by prefered mission type',
  //'Acolytes': 'Notification for when an Acolyte is found',
};

const cycles = {
  NotificationKeys.earthDayKey: 'Earth Day Cycle',
  NotificationKeys.earthNightKey: 'Earth Night Cycle',
  NotificationKeys.dayKey: 'Cetus Day Cycle',
  NotificationKeys.nightKey: 'Cetus Night Cycle',
  NotificationKeys.warmKey: 'Orb Vallis Warm Cycle',
  NotificationKeys.coldKey: 'Orb Vallis Cold Cycle'
};

const newsType = {
  NotificationKeys.newsPrimeKey: 'Prime Access News',
  NotificationKeys.newsStreamKey: 'Stream Announcements',
  NotificationKeys.newsUpdateKey: 'Warframe update News'
};

const acolytes = {
  NotificationKeys.angstkey: 'Angst',
  NotificationKeys.maliceKey: 'Malice',
  NotificationKeys.maniaKey: 'Mania',
  NotificationKeys.miseryKey: 'Misery',
  NotificationKeys.tormentKey: 'Torment',
  NotificationKeys.violenceKey: 'Violence',
};

const Map<String, String> resources = {
  NotificationKeys.sniptronVandalBP: 'Snipetron Vandal Blueprint',
  NotificationKeys.sheeveHeatsink: 'Sheev Heatsink',
  NotificationKeys.deraVandalBarrel: 'Dera Vandal Barrel',
  NotificationKeys.deraVandalBP: 'Dera Vandal Blueprint',
  NotificationKeys.wraithTwinVIpersBarrel: 'Wraith Twin Vipers Barrel',
  NotificationKeys.latronWraithReceiver: 'Latron Wraith Receiver',
  NotificationKeys.fieldron: 'Fieldron',
  NotificationKeys.detoniteInjector: 'Detonite Injector',
  NotificationKeys.aladNavCoordinate: 'Mutalist Alad V Nav Coordinate',
  NotificationKeys.mutagenMass: 'Mutagen Mass',
  NotificationKeys.orokinCatalyst: 'Orokin Catalyst',
  NotificationKeys.orokinReactor: 'Orokin Reactor',
  NotificationKeys.forma: 'Forma',
  NotificationKeys.exilusAdapter: 'Exilus Adapter'
};

const missionTypes = {
  'key': 'missions_alert',
  'missions': [
    'Excavation',
    'Sabotage',
    'Mobile Defense',
    'Assassination',
    'Extermination',
    'Hive',
    'Defense',
    'Interception',
    'Rescue',
    'Spy',
    'Survival',
    'Capture',
    'Hijack',
    'Assault',
    'Defection',
    'Free Roam',
  ]
};
