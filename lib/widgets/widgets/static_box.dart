import 'package:flutter/material.dart';

class StaticBox extends StatelessWidget {
  const StaticBox(
      {this.child,
      this.color,
      this.height,
      this.width,
      this.padding = const EdgeInsets.all(4.0),
      this.margin = const EdgeInsets.all(3.0)});

//create simple text box with hard coded color of white
  factory StaticBox.text(
      {String text,
      Color color,
      double size,
      EdgeInsetsGeometry padding = const EdgeInsets.all(4.0),
      EdgeInsetsGeometry margin = const EdgeInsets.all(3.0)}) {
    return StaticBox(
      padding: padding,
      margin: margin,
      color: color,
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: size)),
    );
  }

  final Color color;
  final Widget child;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding, margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(3.0))),
        child: child);
  }
}