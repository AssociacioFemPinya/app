import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fempinya3_flutter_app/features/home/data/home_service.dart';
import 'package:fempinya3_flutter_app/l10n/app_localizations.dart';

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

    return Scaffold(
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
    );
  }
}

class _NoticiaCard extends StatefulWidget {
  final NoticiaItem noticia;
  const _NoticiaCard({required this.noticia});

  @override
  State<_NoticiaCard> createState() => _NoticiaCardState();
}

class _NoticiaCardState extends State<_NoticiaCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.noticia;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: n.unread
              ? const Icon(Icons.fiber_new, color: Colors.orange)
              : const Icon(Icons.article_outlined, color: Colors.blueGrey),
          title: Text(
            n.title,
            style: TextStyle(
              fontWeight: n.unread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          onTap: () => setState(() => _expanded = !_expanded),
        ),
        if (_expanded && n.body != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Html(
              data: n.body!,
              style: {
                'body': Style(
                  fontSize: FontSize(14),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
              },
            ),
          ),
      ],
    );
  }
}
