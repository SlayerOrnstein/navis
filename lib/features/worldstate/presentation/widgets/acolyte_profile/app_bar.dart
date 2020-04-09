import 'package:flutter/material.dart';
import 'package:navis/core/utils/skybox.dart';

class AcolyteAppBar extends StatelessWidget {
  const AcolyteAppBar(
      {Key key, @required this.acolyteName, @required this.region})
      : assert(acolyteName != null),
        assert(region != null),
        super(key: key);

  final String acolyteName;
  final String region;

  Widget _buildSkybox(ImageProvider imageProvider) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skybox = SkyBoxLoader(context, region);

    return SliverAppBar(
      title: Text(acolyteName),
      backgroundColor: Colors.red[900],
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        title: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 45.0,
          backgroundImage: AssetImage(
            'assets/enemies/stalker/${acolyteName.toLowerCase()}.webp',
          ),
        ),
        centerTitle: true,
        background: FutureBuilder<ImageProvider>(
            initialData: SkyBoxLoader.derelict,
            future: skybox.load(),
            builder:
                (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
              return _buildSkybox(snapshot.data);
            }),
      ),
    );
  }
}