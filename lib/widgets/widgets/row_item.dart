import 'package:flutter/material.dart';

class RowItem extends StatelessWidget {
  const RowItem({
    this.icons = const <Widget>[],
    @required this.text,
    @required this.child,
    this.size,
    this.caption = false,
  });

  factory RowItem.richText(
      {String title, String richText, Color color, double size}) {
    return RowItem(
      text: Text(title),
      child: Text(
        richText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size,
          color: color,
        ),
      ),
    );
  }

  final List<Widget> icons;
  final Widget text;
  final Widget child;
  final double size;
  final bool caption;

  @override
  Widget build(BuildContext context) {
    final _icons = Container(
        child: Row(children: <Widget>[
      if (icons.isNotEmpty)
        ...icons.map((i) =>
            Padding(padding: const EdgeInsets.only(right: 4.0), child: i)),
    ]));

    return Container(
      child: Row(
        children: <Widget>[_icons, text, const Spacer(), child],
      ),
    );
  }
}
