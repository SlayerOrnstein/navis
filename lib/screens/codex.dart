import 'package:flutter/material.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/services/repository.dart';
import 'package:navis/widgets/codex/codex.dart';

class Codex extends StatefulWidget {
  const Codex({Key key}) : super(key: key);

  @override
  _CodexState createState() => _CodexState();
}

class _CodexState extends State<Codex> {
  Repository repository;

  @override
  void initState() {
    super.initState();
    repository = RepositoryProvider.of<Repository>(context);

    repository.loadDropTable();
  }

  @override
  void dispose() {
    repository.disposeDropTable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) {
        return Stack(children: <Widget>[
          const CustomScrollView(
            slivers: <Widget>[SearchBar(), SearchResults()],
          ),
          if (state is SearchStateSuccess && state.results.isEmpty)
            const Center(child: Text('No Results')),
          if (state is SearchStateLoading)
            const Center(child: CircularProgressIndicator()),
          if (state is SearchStateEmpty || state is SearchListenerError)
            const Center(
                child: Text(
                    'Type what you\'re looking for into the search bar above!')),
          if (state is SearchStateError)
            const Center(child: Text('An error has occurred'))
        ]);
      },
    );
  }
}