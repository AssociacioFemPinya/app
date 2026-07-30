import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:femcastells/features/rondes/rondes.dart';
part 'public_display_url_view_event.dart';
part 'public_display_url_view_state.dart';

class PublicDisplayUrlViewBloc
    extends Bloc<PublicDisplayUrlViewEvent, PublicDisplayUrlViewState> {
  PublicDisplayUrlViewBloc() : super(PublicDisplayUrlViewInitial()) {
    on<PublicDisplayUrlLoadEvent>((event, emit) async {
      GetPublicDisplayUrlParams getPublicDisplayUrlParams =
          GetPublicDisplayUrlParams();
      var result = await sl<GetPublicDisplayUrl>()
          .call(params: getPublicDisplayUrlParams);

      result.fold((failure) {
        emit(PublicDisplayUrlLoadFailureState(failure: failure));
      }, (publicDisplayUrl) {
        try {
          _verifyPublicDisplayURL(publicDisplayUrl: publicDisplayUrl);
          emit(PublicDisplayUrlLoadSuccessState(
              publicDisplayUrl: publicDisplayUrl));
        } on EmptyUriException {
          emit(PublicDisplayUrlLoadFailureStateEmptyUri(
              publicDisplayUrl: publicDisplayUrl));
        } on InvalidUriException {
          emit(PublicDisplayUrlLoadFailureStateWrongUri(
              publicDisplayUrl: publicDisplayUrl));
        }
      });
    });
  }

  Uri _verifyPublicDisplayURL({required publicDisplayUrl}) {
    if (publicDisplayUrl.publicUrl.isEmpty) {
      throw EmptyUriException();
    }

    Uri? uri = Uri.tryParse(publicDisplayUrl.publicUrl);
    if (uri == null || uri.scheme.isEmpty || uri.host.isEmpty) {
      throw InvalidUriException();
    }

    return uri;
  }
}
