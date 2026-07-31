import 'package:flutter/material.dart';
import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/core/service_locator.dart';
import 'package:femcastells/features/rondes/data/models/historial.dart';
import 'package:femcastells/features/rondes/data/models/ronda.dart';
import 'package:femcastells/features/rondes/data/sources/rondes_service.dart';
import 'package:femcastells/features/rondes/presentation/widgets/web_view.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  late final Future<List<HistorialEventModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = sl<RondesService>()
        .getHistorial()
        .then((r) => r.fold((_) => [], (list) => list));
  }

  @override
  Widget build(BuildContext context) {
    return ArcMenu(child: Scaffold(
      appBar: AppBar(title: const Text('Historial d\'actuacions')),
      body: FutureBuilder<List<HistorialEventModel>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final events = snap.data ?? [];
          if (events.isEmpty) {
            return const Center(child: Text('Sense actuacions anteriors'));
          }
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, i) => _EventTile(event: events[i]),
          );
        },
      ),
    ));
  }
}

class _EventTile extends StatelessWidget {
  final HistorialEventModel event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.event),
      title: Text(event.eventName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(event.eventDate),
      children: event.rondes.map((r) => _RondaTile(ronda: r)).toList(),
    );
  }
}

class _RondaTile extends StatelessWidget {
  final RondaModel ronda;
  const _RondaTile({required this.ronda});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32, right: 16),
      leading: Text(
        '${ronda.ronda ?? ''}',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      title: Text(ronda.name ?? ''),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MyWebView(url: ronda.publicUrl ?? ''),
        ),
      ),
    );
  }
}
