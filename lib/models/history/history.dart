import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'history.freezed.dart';

part 'history.g.dart';

@freezed
class History with _$History {
  const factory History({
    required String? title,
    required String? url,
  }) = _History;

  factory History.fromJson(Map<String, Object?> json) =>
      _$HistoryFromJson(json);
}
