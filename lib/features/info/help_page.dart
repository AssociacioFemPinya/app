import 'package:flutter/material.dart';
import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return ArcMenu(child: Scaffold(
      appBar: AppBar(title: Text(t.menuHelp)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ajuda', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(
              'Per a qualsevol dubte o suggeriment, contacta amb el responsable de la teva colla '
              'o envia un correu a l\'administrador de l\'aplicació.',
            ),
            SizedBox(height: 24),
            Text('Preguntes freqüents', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('• No veig les meves rondes → Comprova que la teva colla té actuacions publicades.'),
            SizedBox(height: 4),
            Text('• Error d\'inici de sessió → Verifica el correu i la contrasenya.'),
          ],
        ),
      ),
    ));
  }
}
