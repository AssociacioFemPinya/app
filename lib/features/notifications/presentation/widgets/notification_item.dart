import 'package:fempinya3_flutter_app/core/navigation/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/entities/notification.dart';
import 'package:fempinya3_flutter_app/features/notifications/presentation/bloc/notifications_list/notifications_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: notification.isRead 
            ? theme.colorScheme.surface
            : theme.colorScheme.primaryContainer.withAlpha((0.08 * 255).toInt()),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withAlpha((0.1 * 255).toInt()),
          ),
        ),
      ),
      child: InkWell(
        onTap: notification.isRead ? null : () {
          // TODO: Uncomment
          // context.read<NotificationsBloc>().add(
          //   UpdateReadStatusEvent(notification.id),
          // );
          context.pushNamed(notificationRoute, pathParameters: {'notificationID': notification.id.toString()}).then((_) {
            // TODO: refresh after come back from notification view
            //context.read<EventsListBloc>().add(LoadEventsList(context.read<EventsFiltersBloc>().state));
        });
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: notification.isRead 
                ? theme.colorScheme.surfaceContainerHighest
                : theme.colorScheme.primaryContainer,
            child: Icon(
              notification.isRead 
                  ? Icons.notifications_outlined
                  : Icons.notifications_active,
              color: notification.isRead 
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            notification.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    final translate = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return translate.timeAgoSeconds;
    } else if (difference.inHours < 1) {
      return translate.timeAgoMinutes(difference.inMinutes);
    } else if (difference.inDays < 1) {
      return translate.timeAgoHours(difference.inHours);
    } else {
      return translate.timeAgoDays(difference.inDays);
    }
  }
} 