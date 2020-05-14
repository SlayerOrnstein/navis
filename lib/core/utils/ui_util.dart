import 'package:flutter/widgets.dart';

enum DeviceScreenType { mobile, smallTablet, tablet }

class SizingInformation {
  const SizingInformation({
    @required this.deviceScreenType,
    @required this.screenSize,
    @required this.localWidgetSize,
  });

  factory SizingInformation.fromConstraints(
      MediaQueryData mediaQuery, BoxConstraints constraints) {
    return SizingInformation(
      deviceScreenType: mediaQuery.getDeviceType(),
      screenSize: mediaQuery.size,
      localWidgetSize: Size(constraints.maxWidth, constraints.maxHeight),
    );
  }

  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  double get _blockSizeHorizontal => screenSize.shortestSide / 100;
  double get _blockSizeVertical => screenSize.longestSide / 100;

  double get textMultiplier => _blockSizeVertical;
  double get imageSizeMultiplier => _blockSizeHorizontal;
  double get heightMultiplier => _blockSizeVertical;
  double get widthMultiplier => _blockSizeHorizontal;
}

extension on MediaQueryData {
  DeviceScreenType getDeviceType() {
    final deviceWidth = size.shortestSide;

    if (deviceWidth >= 640 && deviceWidth <= 960) {
      return DeviceScreenType.smallTablet;
    } else if (deviceWidth >= 960) {
      return DeviceScreenType.tablet;
    } else {
      return DeviceScreenType.mobile;
    }
  }
}
