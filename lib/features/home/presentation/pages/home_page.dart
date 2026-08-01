import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/features/home/data/home_service.dart';
import 'package:femcastells/features/notifications/presentation/pages/noticia_detail_page.dart';
import 'package:femcastells/features/login/login.dart' hide sl;
import 'package:femcastells/l10n/app_localizations.dart';
import 'package:femcastells/main_routes.dart' show routeObserver;
import 'package:femcastells/services/firebase_notification_service.dart';
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

class _HomePageState extends State<HomePage> with RouteAware {
  final HomeService _service = HomeService();
  late Future<HomeData> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchHome();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkGdpr();
      FirebaseNotificationService.instance.syncToken();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() => _future = _service.fetchHome());
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
          final unread = data.recent.where((n) => n.unread).toList();
          final user = context.read<AuthenticationBloc>().userEntity;
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
                if (unread.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Cap notícia pendent', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ...unread.map((n) => _NoticiaHeadline(noticia: n)),
                const SizedBox(height: 32),
                _BrandLogo(collaLogoUrl: user?.collaLogoUrl),
                const SizedBox(height: 16),
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

class _BrandLogo extends StatelessWidget {
  final String? collaLogoUrl;
  const _BrandLogo({this.collaLogoUrl});

  @override
  Widget build(BuildContext context) {
    const size = 120.0;
    Widget logo;

    if (collaLogoUrl != null) {
      logo = Image.network(
        collaLogoUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _femcastellsLogo(size),
      );
    } else {
      logo = _femcastellsLogo(size);
    }

    return Center(
      child: ClipOval(
        child: SizedBox(width: size, height: size, child: logo),
      ),
    );
  }

  Widget _femcastellsLogo(double size) => SvgPicture.asset(
        'assets/icons/femcastells_logo.svg',
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
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
