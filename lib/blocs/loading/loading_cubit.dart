import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'loading_state.dart';

part 'loading_cubit.freezed.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit()
      : super(const LoadingState.initial(status: LoadingStatus.loaded));

  void loaded() => emit(state.copyWith(status: LoadingStatus.loaded));

  void loading() => emit(state.copyWith(status: LoadingStatus.loading));
}
