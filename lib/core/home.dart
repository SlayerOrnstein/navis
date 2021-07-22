import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simple_icons/simple_icons.dart';

import '../constants/links.dart';
import '../l10n/l10n.dart';
import '../resources/resources.dart';
import 'cubits/navigation_cubit.dart';
import 'notifiers/user_settings_notifier.dart';
import 'settings/settings.dart';
import 'utils/extensions.dart';
import 'utils/helper_methods.dart';
import 'widgets/drawer_options.dart';
import 'widgets/fa_icon.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  Future<bool> _willPop() {
    if (context.read<UserSettingsNotifier>().backKey) {
      if (!scaffold.currentState!.isDrawerOpen) {
        scaffold.currentState!.openDrawer();
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        key: scaffold,
        appBar: AppBar(),
        drawer: const NDrawer(),
        body: BlocBuilder<NavigationCubit, Widget>(
          builder: (BuildContext context, Widget state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: state,
            );
          },
        ),
      ),
    );
  }
}

class NDrawer extends StatelessWidget {
  const NDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mediaQuery = MediaQuery.of(context);

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 20 * (mediaQuery.size.height / 100),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                  child: const Image(
                    image: AssetImage(NavisAssets.derelict),
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  bottom: false,
                  left: false,
                  right: false,
                  top: true,
                  child: SvgPicture.asset(
                    NavisAssets.wfcdLogoColor,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: DrawerOptions()),
          const Divider(height: 4.0),
          ListTile(
            leading: const FaIcon(
              SimpleIcons.discord,
              color: Color(0xFF7289DA),
            ),
            title: Text(l10n.discordSupportTitle),
            onTap: () => discordInvite.launchLink(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.settingsTitle),
            onTap: () {
              final deviceType = getDeviceType(mediaQuery.size);

              if (deviceType != DeviceScreenType.mobile) {
                showDialog(
                  context: context,
                  builder: (_) => const SettingsDialog(),
                );
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/settings');
              }
            },
          ),
        ],
      ),
    );
  }
}
