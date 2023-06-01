part of 'histories_bloc.dart';

@freezed
class HistoriesState with _$HistoriesState {
  const factory HistoriesState.initial({
    required Set<History> histories,
  }) = _Initial;
}
