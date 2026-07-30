import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:femcastells/l10n/app_localizations.dart';
import 'package:femcastells/features/notifications/domain/entities/notification.dart';
import 'package:femcastells/features/notifications/presentation/bloc/notifications_bloc.dart';

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
          context.read<NotificationsBloc>().add(
            UpdateReadStatusEvent(notification.id),
          );
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(context, notification.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha((0.7 * 255).toInt()),
                ),
              ),
            ],
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