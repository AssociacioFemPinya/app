import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femcastells/core/service_locator.dart';
import 'package:femcastells/core/navigation/route_names.dart';

class GdprConsentPage extends StatefulWidget {
  const GdprConsentPage({super.key});

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

  Future<void> _accept() async {
    if (!_accepted) return;
    setState(() => _saving = true);
    try {
      await sl<Dio>().post('/api-fempinya/mobile_gdpr/accept');
      if (mounted) context.goNamed(homeRoute);
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
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));

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
