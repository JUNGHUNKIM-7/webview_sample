import 'package:shared_preferences/shared_preferences.dart';
import '../models/config/config.dart';

enum ConfigKeys {
  name(key: 'name'),
  age(key: 'age');

  final String key;

  const ConfigKeys({required this.key});
}

class GlobalConfigs {
  static late SharedPreferences sf;

  GlobalConfigs._();

  factory GlobalConfigs.getInstance() => GlobalConfigs._();

  static Future<void> initialize() async {
    sf = await SharedPreferences.getInstance();
  }

  Future<void> setConfig(Config config) async {
    final json = config.toJson();
    final len = json.keys.length;
    await Future.wait([
      for (var i = 0; i < len; i++)
        _setByEvalValue(json.keys.elementAt(i), json.values.elementAt(i))
    ]);
  }

  Future<void> changeValue(ConfigKeys keys, dynamic value) async {
    if (sf.containsKey(keys.key)) {
      _setByEvalValue(keys.key, value);
    }
  }

  Future<void> _setByEvalValue(String key, dynamic value) async {
    switch (value.runtimeType) {
      case String:
        await sf.setString(key, value);
        break;
      case int:
        await sf.setInt(key, value);
        break;
      case double:
        await sf.setDouble(key, value);
        break;
      case bool:
        await sf.setBool(key, value);
        break;
      case List:
        await sf.setStringList(key, value);
        break;
      default:
        throw Exception('Type not supported');
    }
  }

  String? getValueFromConfig(ConfigKeys keys) {
    return sf.getString(keys.key);
  }
}
