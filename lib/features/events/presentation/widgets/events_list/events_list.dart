import 'package:femcastells/core/configs/assets/app_icons.dart';
import 'package:femcastells/core/utils/datetime_utils.dart';
import 'package:femcastells/features/events/domain/entities/event.dart';
import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/features/events/domain/enums/events_status.dart';
import 'package:femcastells/features/events/domain/enums/events_type.dart';
import 'package:femcastells/features/events/domain/enums/events_view_mode.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_calendar/events_calendar_bloc.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_list/events_list_bloc.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_view_mode/events_view_mode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsListWidget extends StatelessWidget {
  const EventsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calendarFormat =
        context.watch<EventsCalendarBloc>().state.calendarFormat;
    final eventsViewMode =
        context.watch<EventsViewModeBloc>().state.eventsViewMode;

    return Visibility(
      visible: !(calendarFormat == CalendarFormat.month &&
          eventsViewMode == EventsViewModeEnum.calendar),
      child: _listView(),
    );
  }

  Widget _listView() {
    return BlocBuilder<EventsListBloc, EventsListState>(
      builder: (context, state) {
        final sortedDates = state.events.keys.toList()..sort();
        return ListView.separated(
          itemCount: sortedDates.length,
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 230.0),
              child: DottedLineSeparator(),
            ),
          ),
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final events = state.events[date] ?? [];
            return _buildDateEventsList(date, events, context);
          },
        );
      },
    );
  }

  Widget _buildDateEventsList(
      DateTime date, List<EventEntity> events, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader(date, context),
        Column(
            children: events
                .map((event) => _buildEventCard(event, context))
                .toList()),
      ],
    );
  }
  
  Widget _buildDateHeader(DateTime date, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.calendar_month, color: Colors.black.withOpacity(0.2)),
          const SizedBox(width: 4), 
          Expanded(
            child: Text(
              DateTimeUtils.formatDateToHumanLanguage(
                  date, Localizations.localeOf(context).toString()),
              style: const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 90, 89, 89), 
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventEntity event, BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(eventRoute, pathParameters: {'eventID': event.id.toString()}).then((_) {
          context.read<EventsListBloc>().add(LoadEventsList(context.read<EventsFiltersBloc>().state));
        });
      },
      hoverColor: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.2), // Change hover color here
      splashColor: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.6), 
      focusColor: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.6),
      highlightColor: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.8),// Change click color here
      borderRadius: BorderRadius.circular(5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), 
        side: BorderSide(width: _getStatusBorderSizeCard(event.status), color: _getStatusBorderColorCard(event.status))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: _getStatusBackgroundColor(event.status),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          leading: CircleAvatar(
            backgroundColor: _getStatusBackgroundIconColor(event.status),
            child: Icon(_getStatusIcon(event.status),
                color: _getStatusColor(event.status), 
                size: 35), 
          ),
          title: Text(event.title),
          subtitle: Text('${event.address} - ${event.dateHour}'),
          trailing:
              SvgPicture.asset(_getTypeIcon(event.type), width: 50, height: 50),
        ),
      ),
    );
  }

  IconData _getStatusIcon(EventStatusEnum status) =>
      const {
        EventStatusEnum.accepted: Icons.check,
        EventStatusEnum.declined: Icons.close,
        EventStatusEnum.unknown: Icons.help_outline,
        EventStatusEnum.undefined: Icons.remove,
        EventStatusEnum.warning: Icons.warning,
      }[status] ??
      Icons.help_outline;

  String _getTypeIcon(EventTypeEnum type) =>
      const {
        EventTypeEnum.activity: AppIcons.activityIcon,
        EventTypeEnum.training: AppIcons.trainingIcon,
        EventTypeEnum.performance: AppIcons.performanceIcon,
      }[type] ??
      AppIcons.miniArrowRight;

  Color _getStatusBackgroundColor(EventStatusEnum status) =>
      const {
        EventStatusEnum.accepted: Color.fromRGBO(202, 245, 195, 0.4),
        EventStatusEnum.declined: Color.fromRGBO(245, 127, 141, 0.2),
        EventStatusEnum.unknown: Color.fromRGBO(249, 208, 130, 0.5),
        EventStatusEnum.undefined: Color.fromRGBO(255, 255, 255, 1), 
        EventStatusEnum.warning: Color.fromRGBO(202, 245, 195, 0.4),
      }[status] ??
      const Color.fromRGBO(202, 196, 208, 1);

      Color _getStatusBorderColorCard(EventStatusEnum status) =>
      const {
        EventStatusEnum.accepted: Color.fromRGBO(202, 245, 195, 0.5),
        EventStatusEnum.declined: Color.fromRGBO(245, 127, 141, 0.5),
        EventStatusEnum.unknown: Color.fromRGBO(249, 208, 130, 0.5),
        EventStatusEnum.undefined: Color.fromRGBO(202, 196, 208, 1), 
        EventStatusEnum.warning: Color.fromRGBO(202, 245, 195, 1),
      }[status] ??
      const Color.fromRGBO(202, 196, 208, 1);


   _getStatusBorderSizeCard(EventStatusEnum status) =>
      const {
        EventStatusEnum.accepted: 0.0,
        EventStatusEnum.declined: 0.0,
        EventStatusEnum.unknown: 0.0,
        EventStatusEnum.undefined: 1.0,
        EventStatusEnum.warning: 0.0,
      }[status] ??
      4;

  Color _getStatusBackgroundIconColor(EventStatusEnum status) =>
      const {
        EventStatusEnum.accepted: Color.fromRGBO(202, 245, 195, 0.9),
        EventStatusEnum.declined: Color.fromRGBO(245, 127, 141, 0.5),
        EventStatusEnum.unknown: Color.fromRGBO(249, 208, 130, 0.5),
        EventStatusEnum.undefined: Color.fromRGBO(202, 196, 208, 0.2),
        EventStatusEnum.warning: Color.fromRGBO(202, 245, 195, 0.4),
      }[status] ??
      const Color.fromRGBO(202, 196, 208, 1);

  Color _getStatusColor(EventStatusEnum status) =>
      const {
        EventStatusEnum.accepted: Colors.green,
        EventStatusEnum.declined: Colors.red,
        EventStatusEnum.unknown: Colors.orange,
        EventStatusEnum.undefined: Colors.grey,
        EventStatusEnum.warning: Colors.orange,
      }[status] ??
      Colors.grey;
}


  class DottedLineSeparator extends StatelessWidget {
    const DottedLineSeparator({super.key});

    @override
    Widget build(BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 2.0;
          const dashHeight = 2.0;
          final dashCount = (boxWidth / (4 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              );
            }),
          );
        },
      );
    }
  }