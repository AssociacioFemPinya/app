import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:femcastells/l10n/app_localizations.dart';

import 'package:femcastells/features/rondes/rondes.dart';

class PublicDisplayUrlPage extends StatelessWidget {
  const PublicDisplayUrlPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PublicDisplayUrlViewBloc()
        ..add(PublicDisplayUrlLoadEvent()),
      child: PublicDisplayUrlViewContentsPage(),
    );
  }
}

class PublicDisplayUrlViewContentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocBuilder<PublicDisplayUrlViewBloc, PublicDisplayUrlViewState>(
      builder: (context, state) {
        if (state is PublicDisplayUrlViewInitial) {
          EasyLoading.show(status: 'Loading...');
          return Center(
            child: Text(''),
          );
        } else if (state is PublicDisplayUrlLoadFailureStateEmptyUri ||
            state is PublicDisplayUrlLoadSuccessState ||
            state is PublicDisplayUrlLoadFailureStateWrongUri) {
          EasyLoading.dismiss();
          PublicDisplayUrlViewStateWithUrl s =
              state as PublicDisplayUrlViewStateWithUrl;
          return Scaffold(
            appBar: AppBar(
              title: Text(translate.menuPublicDisplayUrl),
            ),
            body: Center(
              child: _publicDisplayUrlViewContentsBody(s, translate),
            ),
          );
        } else {
          EasyLoading.dismiss();
          return Text('Unimplemented state');
        }
      },
    );
  }

  Widget _publicDisplayUrlViewContentsBody(
      PublicDisplayUrlViewStateWithUrl state, AppLocalizations translate) {
    if (state is PublicDisplayUrlLoadSuccessState) {
      return MyWebView(url: state.publicDisplayUrl.publicUrl);
    } else if (state is PublicDisplayUrlLoadFailureStateEmptyUri) {
      return Text(translate.publicDisplayUrlLoadFailureStateEmptyUri);
    } else if (state is PublicDisplayUrlLoadFailureStateWrongUri) {
      return Text(translate.publicDisplayUrlLoadFailureStateWrongUri);
    } else {
      return Text('Unimplemented state');
    }
  }
}
