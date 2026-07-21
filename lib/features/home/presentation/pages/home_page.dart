import 'package:flutter/material.dart';
import 'package:fempinya3_flutter_app/features/menu/presentation/widgets/menu_widget.dart';
import 'package:fempinya3_flutter_app/features/home/data/home_service.dart';
import 'package:fempinya3_flutter_app/features/notifications/presentation/pages/noticia_detail_page.dart';
import 'package:fempinya3_flutter_app/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeService _service = HomeService();
  late Future<HomeData> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchHome();
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(translate.menuHome)),
      drawer: const MenuWidget(),
      body: FutureBuilder<HomeData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _future = _service.fetchHome());
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _LoginStatsCard(data: data),
                const SizedBox(height: 16),
                _SectionHeader(
                  title: 'Notícies',
                  unreadCount: data.unreadCount,
                ),
                const SizedBox(height: 8),
                if (data.recent.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No hi ha notícies'),
                    ),
                  )
                else
                  ...data.recent.map((n) => _NoticiaHeadline(noticia: n)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoginStatsCard extends StatelessWidget {
  final HomeData data;
  const _LoginStatsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _StatTile(
                label: 'Últim accés',
                value: data.lastLoginAt ?? 'Mai',
                icon: Icons.access_time,
              ),
            ),
            const VerticalDivider(width: 32),
            Expanded(
              child: _StatTile(
                label: 'Total accessos',
                value: data.loginCount.toString(),
                icon: Icons.login,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int unreadCount;
  const _SectionHeader({required this.title, required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (unreadCount > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$unreadCount no llegides',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}

class _NoticiaHeadline extends StatelessWidget {
  final NoticiaItem noticia;
  const _NoticiaHeadline({required this.noticia});

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
      trailing: const Icon(Icons.chevron_right),
      dense: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NoticiaDetailPage(noticia: noticia)),
      ),
    );
  }
}
