import 'package:flutter/material.dart';
import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/features/home/data/home_service.dart';
import 'package:femcastells/features/notifications/presentation/pages/noticia_detail_page.dart';
import 'package:femcastells/features/login/login.dart' hide sl;
import 'package:femcastells/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/core/service_locator.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkGdpr());
  }

  Future<void> _checkGdpr() async {
    try {
      final response = await sl<Dio>().get('/api-fempinya/mobile_gdpr');
      final data = response.data as Map<String, dynamic>;
      debugPrint('[GDPR] required=${data['required']}');
      if ((data['required'] as bool? ?? false) && mounted) {
        context.go(gdprConsentRoute);
      }
    } catch (e) {
      debugPrint('[GDPR] error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return ArcMenu(
      child: Scaffold(
      appBar: AppBar(
        title: Text(translate.menuHome),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.pushNamed(userProfileRoute),
          ),
        ],
      ),
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
                _CollaHeader(),
                const SizedBox(height: 12),
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
    ));
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

class _CollaHeader extends StatelessWidget {
  const _CollaHeader();

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().userEntity;
    final logoUrl = user?.collaLogoUrl;
    final collaName = user?.collaName ?? user?.castellerActiveAlias ?? '';

    if (logoUrl != null) {
      return Row(
        children: [
          Image.network(
            logoUrl,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _CollaNameFallback(name: collaName),
          ),
          const SizedBox(width: 12),
          Text(
            collaName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    if (collaName.isNotEmpty) {
      return _CollaNameFallback(name: collaName);
    }

    return const SizedBox.shrink();
  }
}

class _CollaNameFallback extends StatelessWidget {
  final String name;
  const _CollaNameFallback({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
