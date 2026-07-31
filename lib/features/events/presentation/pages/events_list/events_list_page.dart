import 'package:femcastells/features/events/presentation/bloc/events_list/events_calendar/events_calendar_bloc.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_list/events_list_bloc.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_view_mode/events_view_mode_bloc.dart';
import 'package:femcastells/features/events/presentation/widgets/events_list/events_calendar.dart';
import 'package:femcastells/features/events/presentation/widgets/events_list/events_filters_button.dart';
import 'package:femcastells/features/events/presentation/widgets/events_list/events_filters_input_chips.dart';
import 'package:femcastells/features/events/presentation/widgets/events_list/events_list.dart';
import 'package:femcastells/features/events/presentation/widgets/events_list/events_status_filters.dart';
import 'package:femcastells/features/events/presentation/widgets/events_list/events_view_mode.dart';
import 'package:femcastells/features/events/presentation/widgets/events_list/events_with_alert_banner.dart';
import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class EventsListPage extends StatelessWidget {
  const EventsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    EventsFiltersBloc eventsFiltersBloc = EventsFiltersBloc();

    return MultiBlocProvider(
      providers: [
        BlocProvider<EventsFiltersBloc>(
          create: (context) => eventsFiltersBloc,
        ),
        BlocProvider<EventsViewModeBloc>(
          create: (context) => EventsViewModeBloc(),
        ),
        BlocProvider<EventsListBloc>(
          create: (context) =>
              EventsListBloc()..add(LoadEventsList(eventsFiltersBloc.state)),
        ),
        BlocProvider<EventsCalendarBloc>(
          create: (context) => EventsCalendarBloc(),
        ),
      ],
      child: ArcMenu(child: Scaffold(
          appBar: AppBar(
            title: Text(translate.eventsPageTitle),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<EventsFiltersBloc, EventsFiltersState>(
                // Whenever the filters are changed, we need to refresh the events list
                listener: (context, state) {
                  context.read<EventsListBloc>().add(LoadEventsList(state));
                },
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  EventsWithAlertBannerWidget(),
                  EventsViewModeWidget(),
                  SizedBox(
                    height: 5,
                  ),
                  EventsStatusFiltersWidget(),
                  Row(children: [
                    EventsFiltersButton(),
                    EventsFiltersInputChipsWidget()
                  ]),
                  Divider(),
                  EventsCalendar(),
                  Visibility(
                    child: Expanded(child: EventsListWidget())),
                ],
              ),
            ),
          ))),
    );
  }
}
