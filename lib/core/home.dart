import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../constants/links.dart';
import '../resources/resources.dart';
import 'bloc/navigation_bloc.dart';
import 'local/user_settings.dart';
import 'utils/extensions.dart';
import 'utils/helper_methods.dart';
import 'widgets/drawer_options.dart';
import 'widgets/fa_icon.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  Future<bool> _willPop() {
    if (context.read<Usersettings>().backkey) {
      if (!scaffold.currentState.isDrawerOpen) {
        scaffold.currentState.openDrawer();
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        key: scaffold,
        appBar: AppBar(),
        drawer: Drawer(
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
              Expanded(child: DrawerOptions()),
              const Divider(height: 4.0),
              ListTile(
                leading: const FaIcon(
                  BrandIcons.discord,
                  color: Color(0xFF7289DA),
                ),
                title: const Text('Support'),
                onTap: () => launchLink(context, discordInvite),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(context.locale.settingsTitle),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
            ],
          ),
        ),
        body: BlocBuilder<NavigationBloc, Widget>(
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
