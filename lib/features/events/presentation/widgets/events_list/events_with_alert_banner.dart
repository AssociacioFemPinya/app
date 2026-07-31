import 'package:femcastells/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class EventsWithAlertBannerWidget extends StatelessWidget {
  const EventsWithAlertBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    return BlocBuilder<EventsFiltersBloc, EventsFiltersState>(
        builder: (context, state) {
      return Visibility(
        visible: !state.showWarning,
        child: alertBanner(translate, context),
      );
    });
  }

  Container alertBanner(AppLocalizations translate, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(247, 112, 82, 1), // Color de fondo
        borderRadius: BorderRadius.circular(5.0), // Ajusta el radio aquí
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: Offset(0, 2), // Sombra debajo
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber,
              size: 30,
              color: Colors.white,
            ),
            const SizedBox(width: 8.0), // Espacio entre el ícono y el texto
            Expanded(
              child: Text(
                translate.eventsPageEventsWithAlertBanner,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white, // Color del texto
                ),
                textAlign: TextAlign.left, // Alinea el texto a la izquierda
              ),
            ),
            // Alineación a la derecha
            InkWell(
              onTap: () {
                _onFilterClicked(context);
              },
              child: Text(
                translate.commonFilter,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white, // Color del texto
                  decoration:
                      TextDecoration.underline, // Estilo de hipervínculo
                ),
                textAlign: TextAlign.right, // Alinea el texto a la derecha
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para manejar el clic en el hipervínculo
  void _onFilterClicked(BuildContext context) {
    context.read<EventsFiltersBloc>().add(EventsStatusFilterWarning(true));
  }
}
