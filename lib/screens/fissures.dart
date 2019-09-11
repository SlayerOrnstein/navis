import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/utils/worldstate_utils.dart';
import 'package:navis/widgets/screen_widgets/fissures/fissures.dart';

class FissureList extends StatelessWidget {
  const FissureList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: BlocProvider.of<WorldstateBloc>(context).update,
      child: BlocBuilder<WorldstateBloc, WorldStates>(
        condition: (previous, current) {
          return compareList(
            previous.worldstate?.fissures,
            current.worldstate?.fissures,
          );
        },
        builder: (BuildContext context, WorldStates state) {
          if (state is WorldstateLoaded) {
            final fissures = state.worldstate?.fissures ?? [];

            if (fissures.isNotEmpty) {
              return ListView.builder(
                itemCount: fissures.length,
                cacheExtent: fissures.length / 2,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 2.0,
                    ),
                    child: FissureWidget(fissure: fissures[index]),
                  );
                },
              );
            }

            return const Center(child: Text('No fissures at this Time'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}