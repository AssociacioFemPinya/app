import 'package:fempinya3_flutter_app/features/notifications/data/models/notification_model.dart';

final List<NotificationModel> notificationsMock = [
  NotificationModel(
    sender: 'Some sender',
    id: '1',
    title: 'Nou esdeveniment: Actuació a Plaça Catalunya',
    message: "S'ha programat una nova actuació per dissabte que ve. No oblidis confirmar la teva assistència!",
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
  NotificationModel(
    sender: 'Some sender',
    id: '2',
    title: 'Recordatori: Assaig General',
    message: "Demà tenim assaig general a les 19:00h. És important l'assistència de tothom.",
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: true,
  ),
  NotificationModel(
    sender: 'Some sender',
    id: '3',
    title: "Canvi d'horari",
    message: "L'assaig de dijous s'ha mogut a les 20:00h per problemes de disponibilitat.",
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  NotificationModel(
    sender: 'Some sender',
    id: '4',
    title: 'Nova informació disponible',
    message: "S'ha actualitzat la informació de l'esdeveniment del cap de setmana. Revisa els detalls.",
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
  ),
]; 