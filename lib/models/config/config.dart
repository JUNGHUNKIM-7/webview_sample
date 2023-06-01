import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'config.freezed.dart';

part 'config.g.dart';

@freezed
class Config with _$Config {
  const factory Config({
    required String name,
    required String age,
  }) = _Config;

  factory Config.fromJson(Map<String, Object?> json) => _$ConfigFromJson(json);
}
