import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:femcastells/features/rondes/rondes.dart';

part 'rondes_list_event.dart';
part 'rondes_list_state.dart';

class RondesListBloc extends Bloc<RondesListEvent, RondesListState> {
  RondesListBloc() : super(RondesListInitial()) {
    on<LoadRondesList>((event, emit) async {

      var result =
          await sl<GetRondesList>().call(params: GetRondesListParams());

      result.fold((failure) {
        emit(RondesListLoadFailureState(failure));
      }, (rondes) {
        emit(RondesListLoadSuccessState(rondes));
      });
    });
  }
}
