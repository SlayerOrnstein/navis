import 'package:flutter/material.dart';

class NavisErrorWidget extends StatelessWidget {
  const NavisErrorWidget({
    Key key,
    this.title,
    this.description,
    this.showStacktrace = false,
    this.details,
  }) : super(key: key);

  final String title, description;
  final bool showStacktrace;
  final FlutterErrorDetails details;

  Widget _getStackTraceWidget() {
    bool showStack = showStacktrace;

    assert(showStack = true);
    if (showStack) {
      return LimitedBox(
        maxHeight: 100,
        child: Text(details.exceptionAsString()),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text(
                'There was unexpected error in core system.',
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Reporting error to system admin...',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              _getStackTraceWidget()
            ]),
      ),
    );
  }
}