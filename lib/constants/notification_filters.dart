import 'storage_keys.dart';

const simple = [
  {
    'name': 'Rare Alerts',
    'description': 'Rare alert notifications, mainly gifts of the lotus.',
    'key': NotificationKeys.alertsKey
  },
  {
    'name': 'Baro Ki\'Teer',
    'description': 'For when Baro is arriving or leaving.',
    'key': NotificationKeys.baroKey
  },
  {
    'name': 'Darvo\'s Daily Deals',
    'description': 'Darvo\'s new find of the day',
    'key': NotificationKeys.darvoKey
  },
  {
    'name': 'Sorties',
    'description': 'Notifications for new sorties.',
    'key': NotificationKeys.sortiesKey
  }
];

const filtered = {
  'News': 'News notifications for Prime Access, Streams and Updates.',
  'Cycles': 'Day/Night cycle notifications.',
  'Resources': 'Resources mostly found in invasions.'
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
  NotificationKeys.sniptronVandalBarrel: 'Snipetron Vandal Barrel',
  NotificationKeys.sniptronVandalReceiver: 'Snipetron Vandal Receiver',
  NotificationKeys.sniptronVandalStock: 'Snipetron Vandal Stock',
  NotificationKeys.sheevBP: 'Sheeve Blueprint',
  NotificationKeys.sheevBlade: 'Sheev Blade',
  NotificationKeys.sheevHeatsink: 'Sheev Heatsink',
  NotificationKeys.sheevHilt: 'Sheev Hilt',
  NotificationKeys.deraVandalBP: 'Dera Vandal Blueprint',
  NotificationKeys.deraVandalBarrel: 'Dera Vandal Barrel',
  NotificationKeys.deraVandalReceiver: 'Dera Vandal Receiver',
  NotificationKeys.deraVandalStock: 'Dera Vandal Stock',
  NotificationKeys.wraithTwinVipersBP: 'Wraith Twin Vipers Blueprint',
  NotificationKeys.wraithTwinVipersBarrels: 'Wraith Twin Vipers Barrel',
  NotificationKeys.wraithTwinVipersReceivers: 'Wraith Twin Vipers Receiver',
  NotificationKeys.wraithTwinVipersLink: 'Wraith Twin Vipers Link',
  NotificationKeys.latronWraithBP: 'Latron Wraith Blueprint',
  NotificationKeys.latronWraithBarrel: 'Latron Wraith Barrel',
  NotificationKeys.latronWraithReceiver: 'Latron Wraith Receiver',
  NotificationKeys.latronWraithStock: 'Latron Wraith Stock',
  NotificationKeys.fieldron: 'Fieldron',
  NotificationKeys.detoniteInjector: 'Detonite Injector',
  NotificationKeys.aladNavCoordinate: 'Mutalist Alad V Nav Coordinate',
  NotificationKeys.mutagenMass: 'Mutagen Mass',
  NotificationKeys.orokinCatalyst: 'Orokin Catalyst',
  NotificationKeys.orokinReactor: 'Orokin Reactor',
  NotificationKeys.forma: 'Forma',
  NotificationKeys.exilusAdapter: 'Exilus Adapter',
  NotificationKeys.karakWraithBP: 'Karak Wraith Blueprint',
  NotificationKeys.karakWraithBarrel: 'Karak Wraith Barrel',
  NotificationKeys.karakWraithReceiver: 'Karak Wraith Receiver',
  NotificationKeys.karakWraithStock: 'Karak Wraith Stock',
  NotificationKeys.strunBP: 'Strun Wraith Blueprint',
  NotificationKeys.strunBarrel: 'Strun Wraith Barrel',
  NotificationKeys.strunReciever: 'Strun Wraith Reciever',
  NotificationKeys.strunStock: 'Strun Wraith Stock'
};
