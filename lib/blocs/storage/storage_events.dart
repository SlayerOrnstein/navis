import 'package:equatable/equatable.dart';
import 'package:navis/utils/utils.dart';
import 'package:wfcd_api_wrapper/worldstate_wrapper.dart';

abstract class ChangeEvent extends Equatable {
  const ChangeEvent([List props = const []]) : super(props);
}

class ChangePlatformEvent extends ChangeEvent {
  ChangePlatformEvent(this.platform) : super([platform]);

  final Platforms platform;
}

class ChangeDateFormat extends ChangeEvent {
  ChangeDateFormat(this.dateformat) : super([dateformat]);

  final Formats dateformat;
}

class ToggleNotification extends ChangeEvent {
  ToggleNotification(this.key, this.value, [this.options])
      : super([key, value, options]);

  final String key;
  final bool value;
  final List<String> options;
}
