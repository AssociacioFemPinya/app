import 'package:femcastells/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class EventsStatusFiltersWidget extends StatelessWidget {
  const EventsStatusFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocBuilder<EventsFiltersBloc, EventsFiltersState>(
      builder: (context, state) {
        return Container(
          width: double.infinity, // Hace que el contenedor ocupe todo el ancho
          child: Row(
            children: [
              Expanded(
                child: buildEventStatusFilterButton(
                  state.showUndefined,
                  translate.eventsPageStatusFilterPending,
                  context,
                  (value) {
                    context
                        .read<EventsFiltersBloc>()
                        .add(EventsStatusFilterUndefined(value));
                  },
                  isFirst: true,
                ),
              ),
              Expanded(
                child: buildEventStatusFilterButton(
                  state.showAnswered,
                  translate.eventsPageStatusFilterAnswered,
                  context,
                  (value) {
                    context
                        .read<EventsFiltersBloc>()
                        .add(EventsStatusFilterAnswered(value));
                  },
                ),
              ),
              Expanded(
                child: buildEventStatusFilterButton(
                  state.showWarning,
                  translate.eventsPageStatusFilterWarning,
                  context,
                  (value) {
                    context
                        .read<EventsFiltersBloc>()
                        .add(EventsStatusFilterWarning(value));
                  },
                  isLast: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildEventStatusFilterButton(
      bool selected, String label, BuildContext context, ValueChanged<bool> onSelected,
      {bool isFirst = false, bool isLast = false}) {
    return Container(
      margin: EdgeInsets.zero, // Elimina márgenes
      child: Material(
        shadowColor: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.5),
        elevation: selected ? 1 : 0, // Aplica elevación si está seleccionado
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? Radius.circular(5.0) : Radius.circular(0),
          bottomLeft: isFirst ? Radius.circular(5.0) : Radius.circular(0),
          topRight: isLast ? Radius.circular(5.0) : Radius.circular(0),
          bottomRight: isLast ? Radius.circular(5.0) : Radius.circular(0),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: selected
                ? Theme.of(context).colorScheme.primaryFixedDim
                : Theme.of(context).colorScheme.primaryFixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: isFirst ? Radius.circular(5.0) : Radius.circular(0),
                bottomLeft: isFirst ? Radius.circular(5.0) : Radius.circular(0),
                topRight: isLast ? Radius.circular(5.0) : Radius.circular(0),
                bottomRight: isLast ? Radius.circular(5.0) : Radius.circular(0),
              ),
              side: BorderSide.none, // Elimina el borde
            ),
            padding: EdgeInsets.zero, // Elimina el padding interno
            minimumSize: Size(double.infinity, 48), // Ajusta el tamaño mínimo
          ),
          onPressed: () => onSelected(!selected),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido
            children: [
              if (selected) ...[
                Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  size: 20,
                ),
                SizedBox(width: 8), // Espacio entre el icono y el texto
              ],
              Text(
                label,
                style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected
                      ? Theme.of(context).colorScheme.onPrimaryFixed
                      : Theme.of(context).colorScheme. onPrimaryFixedVariant, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
