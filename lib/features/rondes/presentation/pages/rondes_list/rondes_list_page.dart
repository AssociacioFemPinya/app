import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/features/rondes/rondes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:femcastells/l10n/app_localizations.dart';
import 'package:femcastells/core/navigation/route_names.dart';
import 'package:go_router/go_router.dart';

class RondesListPage extends StatelessWidget {
  const RondesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RondesListBloc>(
          create: (context) => RondesListBloc()..add(LoadRondesList()),
        ),
      ],
      child: RondesListPageContents(),
    );
  }
}

class RondesListPageContents extends StatelessWidget {
  const RondesListPageContents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return ArcMenu(child: Scaffold(
      appBar: AppBar(
        title: Text(translate.menuRondes),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<RondesListBloc, RondesListState>(
          listener: (context, state) {
            if (state is RondesListLoadFailureState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.failure)));
            }
          },
          builder: (context, state) {
            if (state is RondesListLoadSuccessState) {
              if (state.rondes.isEmpty) {
                // Display a message when state.rondes is empty
                return Center(
                  child: Text(AppLocalizations.of(context)!.rondesListEmpty),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: state.rondes.map((ronda) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Ronda ${ronda.ronda}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '  ${ronda.name}'),
                              ],
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.pushNamed(rondaRoute, pathParameters: {
                              'rondaID': ronda.id.toString()
                            });
                          },
                        ),
                        const Divider(height: 1),
                      ],
                    )).toList(),
                  ),
                );
              }
            } else {
              return Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
    ));
  }
}
