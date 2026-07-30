import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_calendar/events_calendar_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_list/events_list_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_view_mode/events_view_mode_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/widgets/events_list/events_calendar.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/widgets/events_list/events_list.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/widgets/events_list/events_toolbar.dart';
import 'package:fempinya3_flutter_app/features/menu/presentation/widgets/menu_widget.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      child: Scaffold(
          appBar: AppBar(
            title: Text(translate.eventsPageTitle),
          ),
          drawer: const MenuWidget(),
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
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  EventsToolbar(),
                  SizedBox(height: 16),
                  EventsCalendar(),
                  EventsListWidget(),
                ],
              ),
            ),
          )),
    );
  }
}
