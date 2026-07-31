import 'package:flutter/material.dart';
import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/features/user_profile/user_profile.dart';
import 'package:femcastells/l10n/app_localizations.dart';
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserProfileEntity? _user;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    final result = await sl<GetUserProfile>().call(params: GetUserProfileParams());
    if (!mounted) return;
    result.fold(
      (err) => setState(() { _loading = false; _error = err; }),
      (user) => setState(() { _loading = false; _user = user; }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return ArcMenu(child: Scaffold(
      appBar: AppBar(
        title: Text(translate.userProfileMenu),
        actions: [
          if (_user != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
                _load();
              },
            ),
        ],
      ),
      body: _buildBody(),
    ));
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!),
          const SizedBox(height: 12),
          FilledButton(onPressed: _load, child: const Text('Reintenta')),
        ]),
      );
    }
    final u = _user!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section('Identificació', [
          _row('Àlies',      u.alias),
          _row('Nom',        '${u.name ?? ''} ${u.lastName ?? ''}'.trim()),
          _row('Naixement',  u.birthdate ?? '—'),
          _row('Núm. soci',  u.numSoci.isEmpty ? '—' : u.numSoci),
        ]),
        _section('Contacte', [
          _row('Correu',       u.email),
          _row('Correu 2',     u.email2.isEmpty ? '—' : u.email2),
          _row('Telèfon',      u.phone.isEmpty ? '—' : u.phone),
          _row('Mòbil',        u.mobilePhone ?? '—'),
          _row('Emergència',   u.emergencyPhone ?? '—'),
        ]),
        _section('Adreça', [
          _row('Adreça',       u.address ?? '—'),
          _row('Codi postal',  u.postalCode ?? '—'),
          _row('Població',     u.city ?? '—'),
          _row('Província',    u.province ?? '—'),
          _row('País',         u.country ?? '—'),
        ]),
      ],
    );
  }

  Widget _section(String title, List<Widget> rows) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
      ),
      ...rows,
      const Divider(height: 24),
    ],
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    ),
  );
}
