import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/notifications_list/notifications_bloc.dart';
import '../widgets/notification_item.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return BlocProvider(
      create: (context) => NotificationsBloc()..add(LoadNotifications()),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          title: Text(translate.notificationsTitle),
          backgroundColor: theme.colorScheme.surface,
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsError) {
              return Center(child: Text(state.message));
            }
            if (state is NotificationsLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NotificationsBloc>().add(LoadNotifications());
                },
                child: state.notifications.isEmpty
                    ? Center(child: Text(translate.notificationsEmpty))
                    : ListView.builder(
                        itemCount: state.notifications.length,
                        itemBuilder: (context, index) {
                          return NotificationItem(
                            notification: state.notifications[index],
                          );
                        },
                      ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
