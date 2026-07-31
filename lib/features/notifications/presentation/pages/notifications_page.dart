import 'package:flutter/material.dart';
import 'package:femcastells/features/home/data/home_service.dart';
import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/features/notifications/presentation/pages/noticia_detail_page.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final HomeService _service = HomeService();
  late Future<List<NoticiaItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchNoticies();
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return ArcMenu(child: Scaffold(
      appBar: AppBar(title: Text(translate.notificationsTitle)),
      body: FutureBuilder<List<NoticiaItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final noticies = snapshot.data!;
          if (noticies.isEmpty) {
            return Center(child: Text(translate.notificationsEmpty));
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _future = _service.fetchNoticies());
            },
            child: ListView.separated(
              itemCount: noticies.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) => _NoticiaCard(noticia: noticies[index]),
            ),
          );
        },
      ),
    ));
  }
}

class _NoticiaCard extends StatelessWidget {
  final NoticiaItem noticia;
  const _NoticiaCard({required this.noticia});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: noticia.unread
          ? const Icon(Icons.fiber_new, color: Colors.orange)
          : const Icon(Icons.article_outlined, color: Colors.blueGrey),
      title: Text(
        noticia.title,
        style: TextStyle(
          fontWeight: noticia.unread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        noticia.publishedAt.substring(0, 10),
        style: const TextStyle(fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NoticiaDetailPage(noticia: noticia)),
      ),
    );
  }
}
