import 'package:customizable_counter/customizable_counter.dart';
import 'package:fempinya3_flutter_app/core/configs/assets/app_icons.dart';
import 'package:fempinya3_flutter_app/core/utils/datetime_utils.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/tag.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/event_view/event_view_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/pages/event_view/views/event_member_comments_screen.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/pages/event_view/views/event_schedule_screen.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/widgets/event_view/assistance_selector.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/widgets/event_view/custom_modal_bottom_sheet.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/widgets/event_view/event_info_tile.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/widgets/event_view/event_questions_section.dart';
import 'package:fempinya3_flutter_app/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventPage extends StatelessWidget {
  final int eventID;

  const EventPage({super.key, required this.eventID});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<EventViewBloc>(
        create: (context) => EventViewBloc()..add(LoadEvent(eventID)),
      ),
    ], child: eventView(context));
  }

  BlocBuilder eventView(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocBuilder<EventViewBloc, EventViewState>(
        builder: (context, state) {
      if (state is EventViewInitial) {
        return Container();
      }
      return BlocListener<EventViewBloc, EventViewState>(
        listener: (context, state) {
          if (state is EventViewEventUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(translate.eventPageAttendanceSaved)),
            );
          }
          if (state is EventViewAnswersSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(translate.eventPageAnswersSaved)),
            );
          }
        },
        child: Scaffold(
            appBar: AppBar(title: Text(state.event!.title)),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                    child: CustomScrollView(
                  slivers: [
                    eventSummary(context),
                    eventDescription(context),
                    schedule(context, translate),
                    addComments(context, translate),
                    SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: attendanceSwitch(context, state, state.event!.isClosed),
                    ),
                    if (state.event?.allowCompanions == true)
                      SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: companionsSelector(context, translate),
                      ),
                    SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: optionsSelector(context, translate),
                    ),
                    if ((state.event?.questions ?? []).isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverToBoxAdapter(
                          child: EventQuestionsSection(
                            questions: state.event!.questions!,
                            readOnly: state.event!.isClosed,
                            onSave: (answers) {
                              context.read<EventViewBloc>().add(
                                SaveAnswers(state.event!.id, answers),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                )))),
      );
    });
  }

  BlocBuilder eventSummary(BuildContext context) {
    return BlocBuilder<EventViewBloc, EventViewState>(
        builder: (context, state) {
      return SliverToBoxAdapter(
        child: Card(
          // Define the shape of the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          // Define how the card's content should be clipped
          clipBehavior: Clip.antiAliasWithSaveLayer,
          // Define the child widget of the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Add padding around the row widget
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //TODO
                    /* // Add an image widget to display an image
                        Image.asset(
                          "foto",
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),*/
                    SvgPicture.asset(
                      AppIcons.activityIcon,
                      width: 100, // Ajusta el ancho del ícono
                      height: 100, // Ajusta la altura del ícono
                    ),
                    // Add some spacing between the image and the text
                    Container(width: 20),
                    // Add an expanded widget to take up the remaining horizontal space
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined,
                                  size: 20),
                              const SizedBox(width: 8),
                              Text(
                                DateTimeUtils.formatDateToHumanLanguage(
                                    state.event?.startDate ??
                                        DateTime.now(), // TO FIX,
                                    Localizations.localeOf(context).toString()),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          Container(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.watch_later, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                state.event?.dateHour ?? "", // TO FIX
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.place, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                state.event?.address ?? "", // TO FIX
                                maxLines: 2,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  BlocBuilder optionsSelector(BuildContext context, translate) {
    return BlocBuilder<EventViewBloc, EventViewState>(
        builder: (context, state) {
      return SliverToBoxAdapter(
          child: Column(
        children: [
          Row(children: [
            SizedBox(height: Theme.of(context).textTheme.bodyLarge?.fontSize),
            Text(
              translate.eventPageAdditionalOptionSelector,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize
                  ),
            ),
          ]),
          SizedBox(height: Theme.of(context).textTheme.bodyLarge?.fontSize),
          SizedBox(
            width: MediaQuery.of(context)
                .size
                .width, // Ajusta al ancho de la pantalla
            child: AdditionalInfoChips(tags: state.event?.tags ?? []),
          )
        ],
      ));
    });
  }

  BlocBuilder companionsSelector(BuildContext context, translate) {
    return BlocBuilder<EventViewBloc, EventViewState>(
      builder: (context, state) {
        return SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: Theme.of(context).textTheme.bodyLarge?.fontSize),
              Row(children: [
                Text(
                  translate.eventPageCompanionsSelector,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize, 
                    ),
                )
                ]),
              SizedBox(height: Theme.of(context).textTheme.bodyLarge?.fontSize),
              CustomizableCounter(
                  borderColor: Theme.of(context).colorScheme.primaryFixedDim,
                  borderWidth: 0,
                  borderRadius: 100,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryFixedDim,
                  buttonText: "Afegir acompanyats",
                  textColor: Theme.of(context).colorScheme.onPrimaryFixed,
                  textSize: 15,
                  count: (state.event?.companions ?? 0).toDouble(),
                  step: 1,
                  minCount: 0,
                  incrementIcon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  decrementIcon: Icon(
                    Icons.remove,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onCountChange: (count) {
                    context
                        .read<EventViewBloc>()
                        .add(EventCompanionsModified(count.toInt()));
                  }),
            ],
          ),
        );
      },
    );
  }

  SliverToBoxAdapter attendanceSwitch(BuildContext context, state, bool disabled) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: Theme.of(context).textTheme.bodyLarge?.fontSize),
          Row(
            children: [
                Text(
                AppLocalizations.of(context)!
                  .eventsPageAttendaceQuestion(state.event!.title),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  ),
                )
            ],
          ),
          if (disabled)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.eventPageClosedBanner,
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
              ),
            ),
          SizedBox(height: Theme.of(context).textTheme.bodyLarge?.fontSize),
          IgnorePointer(
            ignoring: disabled,
            child: Opacity(
              opacity: disabled ? 0.5 : 1.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const AssistanceSelector(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder addComments(BuildContext context, translate) {
    return BlocBuilder<EventViewBloc, EventViewState>(
        builder: (context, state) {
      return EventInfoTile(
          svgSrc: AppIcons.scheduleHours,
          title:  translate.eventPageAddCommentsTitle, 
          isShowBottomTop: false,
          press: () {
            customModalBottomSheet(
              context,
              height: MediaQuery.of(context).size.height - 100,
              child: BlocProvider<EventViewBloc>.value(
                value: context.read<EventViewBloc>(),
                child: EventMemberCommentsScreen(event: state.event!),
              ),
            );
          });
    });
  }

  BlocBuilder schedule(BuildContext context, translate) {

    return BlocBuilder<EventViewBloc, EventViewState>(
        builder: (context, state) {
      return EventInfoTile(
          svgSrc: AppIcons.scheduleHours,
          title: translate.eventPageScheduleTitle, 
          press: () {
            customModalBottomSheet(context,
                height: MediaQuery.of(context).size.height - 100,
                child: EventScheduleScreen(event: state.event!));
          });
    });
  }

  BlocBuilder eventInfo(BuildContext context) {
    return BlocBuilder<EventViewBloc, EventViewState>(
        builder: (context, state) {
      return Card(
        // Define the shape of the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        // Define how the card's content should be clipped
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // Define the child widget of the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add padding around the row widget
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //TODO
                  /* // Add an image widget to display an image
                        Image.asset(
                          "foto",
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),*/
                  SvgPicture.asset(
                    AppIcons.activityIcon,
                    width: 100, // Ajusta el ancho del ícono
                    height: 100, // Ajusta la altura del ícono
                  ),
                  // Add some spacing between the image and the text
                  Container(width: 20),
                  // Add an expanded widget to take up the remaining horizontal space
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              DateTimeUtils.formatDateToHumanLanguage(
                                  state.event!.startDate,
                                  Localizations.localeOf(context).toString()),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        Container(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.watch_later, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              state.event!.dateHour,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Container(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.place, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              state.event!.address,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  BlocBuilder eventDescription(BuildContext context) {
    return BlocBuilder<EventViewBloc, EventViewState>(
        builder: (context, state) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            state.event?.description ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    });
  }
}

class AdditionalInfoChips extends StatelessWidget {
  final List<TagEntity>? tags;
  final Map<String, bool> eventTags;

  AdditionalInfoChips({required this.tags, super.key})
      : eventTags = {for (var tag in tags ?? []) tag.name: tag.isEnabled};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: <Widget>[
          for (var item in eventTags.entries)
            FilterChip(
              onSelected: (selection) {
                context.read<EventViewBloc>().add(EvenTagModified(item.key));
              },
              selected: item.value,
              label: Text(item.key),
              selectedColor: Theme.of(context).colorScheme.primaryFixedDim,
              checkmarkColor: Theme.of(context).colorScheme.onPrimaryFixed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: const BorderSide(style: BorderStyle.none)),
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primaryFixedDim
                  .withOpacity(0.3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
        ],
      ),
    );
  }
}
