import 'package:femcastells/features/events/domain/entities/event.dart';
import 'package:flutter/material.dart';
import 'package:femcastells/core/theme_constants.dart';
import 'package:femcastells/l10n/app_localizations.dart';


class EventScheduleScreen extends StatelessWidget {
  final EventEntity event;

  const EventScheduleScreen({super.key, required this.event});


  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 40,
                    child: BackButton(),
                  ),
                  Text(
                    translate.commonReturn,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Text(
                "Aquí va la tabla de horarios del evento", // TODO
              ),
            )
          ],
        ),
      ),
    );
  }
}