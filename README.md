# Cephalon Navis
[![Build Status](https://travis-ci.com/WFCD/navis.svg?branch=master)](https://travis-ci.com/WFCD/navis)

<a href='https://play.google.com/store/apps/details?id=com.cephalon.navis&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='en_get.svg' width="40%"/></a>


Cephalon Navis is an Android app inspired by [Warframe Hub](https://hub.warframestat.us/). Navis for short uses the [WarframeStat.us API](https://docs.warframestat.us/) to display as much useful and necessary information to help you as you travel the solar system without leaving your game.

### Features:
- Display game news including updates
- Supports displaying multiple events
- information on acolytes
- Cetus and Earth Day/Night cycle
- Orb vallis Warm/Cold cycle
- Ostron and Solaris United bounties with Timer
- Void Fissures
- Nightwaves
- Baro Timer and Inventory
- Display Soties and Invasions
- Links to useful guides for new players to learn how to fish and maps
- Darvo Deals
- supports PC, PS4, Xbox and switch worldstates

### Upcoming Features:
- Notifications (soon)
- Flash sales (This depends on who actually uses it, so if you use it let me know)


# Build Instructions

To build Navis you must first install Flutter from the link below and follow all the instructions needed to get it running for your desired device* then simple run:

```
flutter packages get
flutter build apk
flutter install
```

For Flutter 1.6.3+ replace ```flutter packages get``` with ```flutter pub get```  

Optionally ```flutter build apk --target-platform=android-arm64``` will build for arm64 devices


make sure that you follow all the instructions and everything should run smoothly, unless there's a bug in which case report issues [here](https://github.com/WFCD/navis/issues) so that they may be fixed.

*Note although the app was built using the flutter engine I have not tested it on IOS due to not owing a IDevice or OSX to test on. Might not even compile properly. And a few of the plugins used in this app are not compatible with IOS

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/docs).