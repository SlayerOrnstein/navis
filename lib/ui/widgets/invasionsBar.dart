import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:navis/utils/factionutils.dart';

class InvasionBar extends StatelessWidget {
  final factionutils = Factionutils();

  final String attackingFaction, defendingFaction;
  final double progress;
  final double width;
  final double lineHeight;
  final EdgeInsets padding;
  final Color color;

  InvasionBar(
      {this.progress,
      this.width,
      this.padding,
      @required this.attackingFaction,
      @required this.defendingFaction,
      this.color,
      this.lineHeight})
      : assert(attackingFaction != null),
        assert(defendingFaction != null),
        assert(progress != null);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                      height: lineHeight * 2,
                      width: width,
                      padding: padding,
                      child: CustomPaint(
                          willChange: true,
                          painter: _InvasionBar(
                              progress: progress,
                              progressColor:
                                  factionutils.factionColor(attackingFaction),
                              backgroundColor:
                                  factionutils.factionColor(defendingFaction),
                              lineWidth: lineHeight),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                factionutils.factionIcon(attackingFaction,
                                    size: 15, hasColor: false),
                                factionutils.factionIcon(defendingFaction,
                                    size: 15, hasColor: false),
                              ]))))
            ]));
  }
}

class _InvasionBar extends CustomPainter {
  final Paint _attackingFaction = Paint();
  final Paint _defendingFaction = Paint();
  final Color backgroundColor;
  final Color progressColor;
  final double progress;
  final double lineWidth;

  _InvasionBar(
      {this.progress,
      this.progressColor,
      this.backgroundColor,
      this.lineWidth}) {
    _attackingFaction.color = progressColor;
    _attackingFaction.style = PaintingStyle.stroke;
    _attackingFaction.strokeWidth = lineWidth;
    _attackingFaction.strokeCap = StrokeCap.butt;

    _defendingFaction.color = backgroundColor;
    _defendingFaction.style = PaintingStyle.stroke;
    _defendingFaction.strokeWidth = lineWidth;
    _defendingFaction.strokeCap = StrokeCap.butt;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(0.0, size.height / 2);
    final end = Offset(size.width, size.height / 2);

    canvas.drawLine(start, end, _defendingFaction);
    canvas.drawLine(start, Offset(size.width * progress, size.height / 2),
        _attackingFaction);
  }

  @override
  bool shouldRepaint(_InvasionBar oldDelegate) {
    if (oldDelegate.progress != this.progress) return true;
    return false;
  }
}
