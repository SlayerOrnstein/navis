import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    this.title,
    this.color,
    this.margin = const EdgeInsets.all(4.0),
    this.padding = const EdgeInsets.all(4.0),
    required this.child,
  }) : super(key: key);

  final String? title;
  final Color? color;
  final EdgeInsetsGeometry margin, padding;
  final Widget child;

  Widget _buildTitle(BuildContext context, String text) {
    final titleStyle = Theme.of(context)
        .textTheme
        .headline6
        ?.copyWith(fontWeight: FontWeight.w500);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title!,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
    );
  }

  static const double _defaultElevation = 1.0;
  static const _semanticContainer = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = CardTheme.of(context);
    final cardContent = Padding(
      padding: padding,
      child: title != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_buildTitle(context, title!), child],
            )
          : child,
    );

    return Semantics(
      container: _semanticContainer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: margin,
        child: Material(
          type: MaterialType.card,
          shadowColor: cardTheme.shadowColor ?? theme.shadowColor,
          color: color ?? cardTheme.color ?? theme.cardColor,
          elevation: cardTheme.elevation ?? _defaultElevation,
          shape: cardTheme.shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
          borderOnForeground: true,
          clipBehavior: cardTheme.clipBehavior ?? Clip.none,
          child: Semantics(
            explicitChildNodes: !_semanticContainer,
            child: cardContent,
          ),
        ),
      ),
    );
  }
}
