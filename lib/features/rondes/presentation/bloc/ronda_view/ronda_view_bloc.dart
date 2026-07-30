import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:femcastells/features/rondes/rondes.dart';

part 'ronda_view_event.dart';
part 'ronda_view_state.dart';

class RondaViewBloc extends Bloc<RondaViewEvent, RondaViewState> {
  RondaViewBloc() : super(RondaViewInitial()) {
    on<RondaLoadEvent>((event, emit) async {
      GetRondaParams getRondaParams = GetRondaParams(id: event.id);
      var result = await sl<GetRonda>().call(params: getRondaParams);

      result.fold((failure) {
        emit(RondaViewLoadFailureState(failure: failure));
      }, (ronda) {
        try {
          verifyURI(ronda: ronda);
          emit(RondaViewLoadSuccessState(ronda: ronda));
        } on EmptyUriException {
          emit(RondaViewLoadFailureStateEmptyUri(ronda: ronda));
        } on InvalidUriException {
          emit(RondaViewLoadFailureStateWrongUri(ronda: ronda));
        }
      });
    });
  }

  Uri verifyURI({required RondaEntity ronda}) {
    if (ronda.publicUrl.isEmpty) {
      throw EmptyUriException();
    }

    Uri? uri = Uri.tryParse(ronda.publicUrl);
    if (uri == null || uri.scheme.isEmpty || uri.host.isEmpty) {
      throw InvalidUriException();
    }

    return uri;
  }
}
