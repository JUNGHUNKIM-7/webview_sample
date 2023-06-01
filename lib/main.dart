import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'inh.dart';
import 'global_configs.dart';
import 'blocs/histories/histories_bloc.dart';
import 'blocs/loading/loading_cubit.dart';
import 'pages/home.dart';
import 'utils/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    GlobalConfigs.initialize(),
    PathHandler.initialize(),
  ]);

  runApp(
    Configs(
      children: [
        GlobalConfigs.getInstance(),
        PathHandler.getInstance(),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: _router,
      theme: _theme,
    );
  }

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        name: 'home',
        path: '/',
        builder: (BuildContext _, GoRouterState __) {
          return const Home();
        },
      ),
    ],
  );

  final ThemeData _theme = ThemeData(
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.black87,
        letterSpacing: 0.1,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    useMaterial3: true,
  );
}

class BlocProviderMain extends StatelessWidget {
  const BlocProviderMain({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HistoriesBloc>(
          create: (context) => HistoriesBloc(),
        ),
        BlocProvider<LoadingCubit>(
          create: (context) => LoadingCubit(),
        ),
      ],
      child: child,
    );
  }
}
