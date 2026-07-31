import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:femcastells/features/events/domain/enums/events_view_mode.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_calendar/events_calendar_bloc.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_calendar/events_calendar_events.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_view_mode/events_view_mode_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class EventsViewModeWidget extends StatefulWidget {
  const EventsViewModeWidget({super.key});

  @override
  State<EventsViewModeWidget> createState() => _EventsViewModeWidgetState();
}

class _EventsViewModeWidgetState extends State<EventsViewModeWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late EventsViewModeEnum _currentViewMode;

  late Map<EventsViewModeEnum, int> tabIndexMap = {
    EventsViewModeEnum.list: 0,
    EventsViewModeEnum.calendar: 1,
  };

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabIndexMap.length, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          EventsViewModeEnum selectedMode = tabIndexMap.entries
              .firstWhere((entry) => entry.value == _tabController.index)
              .key;
          _onTabChanged(selectedMode);
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<EventsViewModeBloc>().state;
      _currentViewMode = state.eventsViewMode;
      _tabController.index = tabIndexMap[_currentViewMode]!;
    });
  }

  void _onTabChanged(EventsViewModeEnum viewMode) {
    context.read<EventsViewModeBloc>().add(EventsViewModeSet(viewMode));
    if (viewMode == EventsViewModeEnum.list) {
      context.read<EventsFiltersBloc>().add(EventsDayFilterUnset());
    } else if (viewMode == EventsViewModeEnum.calendar) {
      context.read<EventsCalendarBloc>().add(LoadCalendarEvents());
      context.read<EventsCalendarBloc>().add(EventsCalendarDateSelectedUnset());
      context
          .read<EventsCalendarBloc>()
          .add(EventsCalendarFormatSet(CalendarFormat.month));
    }
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    final Map<EventsViewModeEnum, Tab> tabs = {
      EventsViewModeEnum.list: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.list, size: 20),
            const SizedBox(width: 8),
            Text(translate.eventsPageEventViewModeList,  
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      EventsViewModeEnum.calendar: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_month, size: 20),
            const SizedBox(width: 8),
            Text(translate.eventsPageEventViewModeCalendar,
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    };
    
    return BlocBuilder<EventsViewModeBloc, EventsViewModeState>(
      builder: (context, state) {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DecoratedBox(
                decoration: BoxDecoration( border: Border.all(color: Theme.of(context).colorScheme.primaryFixedDim,
                width: 1.0) ,
                   borderRadius:  const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0)
                      ),
                  color: Theme.of(context)
                    .colorScheme
                    .primaryFixed
                ),
                child: TabBar(
                    controller: _tabController,
                    tabs: tabs.values.toList(),
                    labelColor: Theme.of(context).colorScheme.onPrimaryFixed,
                    unselectedLabelColor: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                    indicator: BoxDecoration(
                       borderRadius:  BorderRadius.only(
                         topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0)
                      ),
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                    ),
                    indicatorPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    padding: EdgeInsets.zero,
                    dividerColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.resolveWith(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.transparent; // Color for hover state
                      }
                      return Colors.transparent; // Default color
                    }))));
      },
    );
  }
}
