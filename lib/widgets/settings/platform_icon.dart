import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/constants/storage_keys.dart';
import 'package:navis/repository/notification_repository.dart';
import 'package:navis/resources/storage/persistent.dart';
import 'package:navis/utils/enums.dart';
import 'package:navis/utils/size_config.dart';
import 'package:navis/widgets/icons.dart';

const pc = 'PC';
const ps4 = 'Sony PlayStation 4';
const xb1 = 'Microsoft Xbox One';
const swi = 'Nintendo Switch';

class PlatformIcon extends StatelessWidget {
  const PlatformIcon({Key key, this.platform}) : super(key: key);

  final Platforms platform;

  static String _tooltip;
  static IconData _platformIcon;
  static Color _platformColor;

  void _setValues() {
    switch (platform) {
      case Platforms.ps4:
        _tooltip = ps4;
        _platformIcon = PlatformIcons.playstation;
        _platformColor = const Color(0xFF003791);
        break;
      case Platforms.xb1:
        _tooltip = xb1;
        _platformIcon = PlatformIcons.xbox;
        _platformColor = const Color(0xFF107C10);
        break;
      case Platforms.swi:
        _tooltip = swi;
        _platformIcon = PlatformIcons.nintendoswitch;
        _platformColor = const Color(0xFFE60012);
        break;
      default:
        _tooltip = pc;
        _platformIcon = PlatformIcons.steam;
        _platformColor = const Color(0xFFFACA04);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig.imageSizeMultiplier * 8.5;

    final state = BlocProvider.of<WorldstateBloc>(context);
    final persistent = RepositoryProvider.of<PersistentResource>(context);

    void _onPressed() {
      NotificationRepository.subscribeToPlatform(
        previousPlatform: persistent.platform,
        currentPlatform: platform,
      );

      persistent.platform = platform;
      state.update();
    }

    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: persistent.watchBox(key: SettingsKeys.platformKey),
      builder: (context, box, child) {
        _setValues();

        return IconButton(
          tooltip: _tooltip,
          splashColor: _platformColor,
          icon: Icon(
            _platformIcon,
            color: persistent.platform == platform
                ? _platformColor
                : Theme.of(context).disabledColor,
            size: size,
            semanticLabel: _tooltip,
          ),
          onPressed: _onPressed,
        );
      },
    );
  }
}
