import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:femcastells/core/service_locator.dart';
import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/features/login/login.dart' hide sl;
import 'package:femcastells/features/rondes/presentation/widgets/web_view.dart';
import 'package:femcastells/global_endpoints.dart';

class GdprConsentPage extends StatefulWidget {
  /// [fromMenu] = true quan s'accedeix des del menú (mode consulta).
  /// [fromMenu] = false (per defecte) = flux obligatori en el login.
  final bool fromMenu;
  const GdprConsentPage({super.key, this.fromMenu = false});

  @override
  State<GdprConsentPage> createState() => _GdprConsentPageState();
}

class _GdprConsentPageState extends State<GdprConsentPage> {
  bool _loading  = true;
  bool _saving   = false;
  bool _accepted = false;
  String? _text;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    // En mode consulta, el contingut ve del WebView — no cal carregar l'API.
    if (widget.fromMenu) {
      setState(() => _loading = false);
      return;
    }
    try {
      final response = await sl<Dio>().get('/api-fempinya/mobile_gdpr');
      final data = response.data as Map<String, dynamic>;
      if (data['required'] == false) {
        if (mounted) context.goNamed(homeRoute);
        return;
      }
      setState(() {
        _text    = data['text'] as String?;
        _loading = false;
      });
    } catch (e) {
      setState(() { _loading = false; _error = e.toString(); });
    }
  }

  Future<void> _reject() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('No acceptes la política de privacitat'),
        content: const Text(
          'Si no acceptes, no podràs utilitzar l\'aplicació i se\'t desconnectarà.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel·lar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Desconnectar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<AuthenticationBloc>().add(AuthenticationLogoutPressed());
    }
  }

  Future<void> _accept() async {
    if (!_accepted) return;
    setState(() => _saving = true);
    try {
      await sl<Dio>().post('/api-fempinya/mobile_gdpr/accept');
      if (mounted) {
        if (widget.fromMenu) {
          context.pop();
        } else {
          context.goNamed(homeRoute);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protecció de dades personals'),
        automaticallyImplyLeading: widget.fromMenu,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));

    if (widget.fromMenu) {
      return Column(
        children: [
          Expanded(
            child: MyWebView(
              url: '${GlobalEndpoints.apiBaseUrl}/privacy',
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CheckboxListTile(
                  value: _accepted,
                  onChanged: (v) => setState(() => _accepted = v ?? false),
                  title: const Text(
                    'He llegit i accepto la política de protecció de dades',
                    style: TextStyle(fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 4),
                FilledButton(
                  onPressed: _accepted && !_saving ? _accept : null,
                  child: _saving
                      ? const SizedBox(
                          height: 18, width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Acceptar i continuar'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(color: Theme.of(context).colorScheme.error),
                  ),
                  onPressed: _reject,
                  child: const Text('No accepto — Desconnectar'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(_text ?? '', style: const TextStyle(fontSize: 14, height: 1.6)),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CheckboxListTile(
                value: _accepted,
                onChanged: (v) => setState(() => _accepted = v ?? false),
                title: const Text(
                  'He llegit i accepto la política de protecció de dades',
                  style: TextStyle(fontSize: 14),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _accepted && !_saving ? _accept : null,
                child: _saving
                    ? const SizedBox(
                        height: 18, width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Acceptar i continuar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
