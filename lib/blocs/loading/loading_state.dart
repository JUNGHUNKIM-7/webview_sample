part of 'loading_cubit.dart';

enum LoadingStatus { loading, loaded }

@freezed
class LoadingState with _$LoadingState {
  const factory LoadingState.initial({
    required LoadingStatus status,
  }) = _Initial;
}
