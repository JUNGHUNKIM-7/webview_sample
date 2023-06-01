import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/history/history.dart';

part 'histories_event.dart';

part 'histories_state.dart';

part 'histories_bloc.freezed.dart';

class HistoriesBloc extends Bloc<HistoriesEvent, HistoriesState> {
  HistoriesBloc()
      : super(const HistoriesState.initial(histories: <History>{})) {
    on<HistoriesEvent>((event, emit) {
      event.map(
        add: (e) => _add(e, emit),
      );
    });
  }

  void _add(HistoriesEvent e, Emitter<HistoriesState> emit) {
    emit(state.copyWith(histories: {...state.histories, e.history}));
  }
}
