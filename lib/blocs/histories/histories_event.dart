part of 'histories_bloc.dart';

@freezed
class HistoriesEvent with _$HistoriesEvent {
  const factory HistoriesEvent.add({
    required History history,
  }) = _Add;
}
