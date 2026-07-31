import 'package:femcastells/features/menu/domain/entities/locale.dart';
import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/features/login/login.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    var selectedLocale = Localizations.localeOf(context).toString();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(context, translate),
          _buildListTile(context, translate.menuHome, homeRoute),
          _buildListTile(context, translate.menuEvents, eventsRoute),
          _buildListTile(
              context, translate.menuNotifications, notificationsRoute),
          _buildListTile(context, translate.menuRondes, rondesRoute),
          _buildListTile(context, 'Historial', historialRoute),
          _buildListTile(
              context, translate.menuPublicDisplayUrl, publicDisplayUrlRoute),
          const Divider(),
          _buildLocaleDropdown(context, translate, selectedLocale),
          const Divider(),
          _buildDisconnect(context, translate.menuDisconnect),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, AppLocalizations translate) {
    final user = context.read<AuthenticationBloc>().userEntity!;
    final logoUrl = user.collaLogoUrl;
    final collaName = user.collaName ?? user.castellerActiveAlias;

    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (logoUrl != null) ...[
            Image.network(
              logoUrl,
              height: 56,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            collaName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: logoUrl != null ? 13 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, String routeName) {
    return ListTile(
      title: Text(title),
      onTap: () {
        context.pushNamed(routeName);
      },
    );
  }

  Widget _buildLocaleDropdown(
      BuildContext context, AppLocalizations translate, String selectedLocale) {
    return Consumer<LocaleModel>(
      builder: (context, localeModel, child) {
        return ListTile(
          title: DropdownButton<String>(
            value: selectedLocale,
            items: ['en', 'es', 'ca', 'fr'].map((String locale) {
              return DropdownMenuItem<String>(
                value: locale,
                child: Text(translate.menuLanguageSettings(locale)),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                localeModel.set(Locale(value));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildDisconnect(BuildContext context, String menuDisconnect) {
    return ListTile(
      title: Text(menuDisconnect),
      onTap: () {
        context.read<AuthenticationBloc>().add(AuthenticationLogoutPressed());
      },
    );
  }
}
