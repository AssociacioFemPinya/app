import 'package:flutter/material.dart';
import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return ArcMenu(child: Scaffold(
      appBar: AppBar(title: Text(t.menuAbout)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FemCastells', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(
              'FemCastells és una aplicació de gestió per a colles castelleres. '
              'Permet als castellers consultar events, rondes de pinya i historial d\'actuacions.',
            ),
            SizedBox(height: 24),
            Text('Versió', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('1.0'),
            SizedBox(height: 16),
            Text('Desenvolupat per', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('Pepe Martín Artacho'),
          ],
        ),
      ),
    ));
  }
}
