import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/histories/histories_bloc.dart';
import '../blocs/loading/loading_cubit.dart';

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
