import 'package:fempinya3_flutter_app/features/menu/domain/entities/locale.dart';
import 'package:fempinya3_flutter_app/core/navigation/route_names.dart';
import 'package:fempinya3_flutter_app/features/login/login.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          _buildListTile(
              context, translate.menuPublicDisplayUrl, publicDisplayUrlRoute),
          _buildListTile(context, translate.userProfileMenu, userProfileRoute),
          const Divider(),
          _buildLocaleDropdown(context, translate, selectedLocale),
          const Divider(),
          _buildDisconnect(context, translate.menuDisconnect),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, AppLocalizations translate) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        translate.menuAppName(context
            .read<AuthenticationBloc>()
            .userEntity!
            .castellerActiveAlias),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, String routeName) {
    return ListTile(
      title: Text(title),
      onTap: () {
        context.goNamed(routeName);
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
