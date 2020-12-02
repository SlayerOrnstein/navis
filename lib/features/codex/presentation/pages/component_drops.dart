import 'package:flutter/material.dart';
import 'package:warframestat_api_models/entities.dart';

class ComponentDrops extends StatelessWidget {
  const ComponentDrops({Key key, @required this.drops})
      : assert(drops != null),
        super(key: key);

  final List<Drop> drops;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        cacheExtent: 150,
        itemCount: drops.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(drops[index].location),
            subtitle: Text('${drops[index].chance}% drop chance'),
            dense: drops.length > 10,
          );
        },
      ),
    );
  }
}