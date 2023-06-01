import 'package:flutter/material.dart';

import '../global_configs.dart';
import '../inh.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = Configs.of<GlobalConfigs>(context, loc: Location.sf);

    return Drawer(
      child: Column(
        children: [
          Text('${config.getValueFromConfig(ConfigKeys.name)}'),
          Text('${config.getValueFromConfig(ConfigKeys.age)}'),
        ],
      ),
    );
  }
}
