import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/features/rondes/rondes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class RondaPage extends StatelessWidget {
  const RondaPage({Key? key, required this.rondaID}) : super(key: key);

  final int rondaID;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<RondaViewBloc>(
        create: (context) => RondaViewBloc()..add(RondaLoadEvent(id: rondaID)),
      )
    ], child: RondaViewContentsPage());
  }
}

class RondaViewContentsPage extends StatelessWidget {
  const RondaViewContentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    return BlocBuilder<RondaViewBloc, RondaViewState>(builder: (context, s) {
      if (s is RondaViewInitial) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (s is RondaViewLoadSuccessState ||
          s is RondaViewLoadFailureStateEmptyUri ||
          s is RondaViewLoadFailureStateWrongUri) {
        RondaViewLoadStateWithRonda state = s as RondaViewLoadStateWithRonda;
        return ArcMenu(child: Scaffold(
          appBar: AppBar(
            title: Text(translate.rondesListRondaButton(
                state.ronda.id, state.ronda.name)),
          ),
          body: Center(
            child: _rondaViewContentsBody(state, translate),
          ),
        ));
      } else {
        return Text('Unknown state');
      }
    });
  }

  Widget _rondaViewContentsBody(
      RondaViewLoadStateWithRonda state, AppLocalizations translate) {
    if (state is RondaViewLoadSuccessState) {
      return MyWebView(url: state.ronda.publicUrl);
    } else if (state is RondaViewLoadFailureStateEmptyUri) {
      return Text(translate.rondaViewLoadFailureStateEmptyUri);
    } else if (state is RondaViewLoadFailureStateWrongUri) {
      return Text(translate.rondaViewLoadFailureStateWrongUri);
    } else {
      return Text('Unknown state');
    }
  }
}
