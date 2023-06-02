import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../blocs/loading/loading_cubit.dart';
import '../blocs/histories/histories_bloc.dart';
import '../utils/string_util.dart';
import '../components/drawer.dart';
import '../models/history/history.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String root = 'https://www.wikipedia.org';
  late WebViewController _webViewController;
  late LoadingCubit loadingCubit;
  late HistoriesBloc historiesBloc;

  @override
  void initState() {
    loadingCubit = LoadingCubit();
    historiesBloc = HistoriesBloc();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            loadingCubit.loading();
          },
          onPageFinished: (String url) async {
            await Future.wait([
              _webViewController.currentUrl(),
              _webViewController.getTitle(),
            ]).then((data) {
              loadingCubit.loaded();
              if (!historiesBloc.state.histories.any(
                    (e) => e.title == data.last || e.url == data.first,
                  ) &&
                  (url != root)) {
                historiesBloc.add(
                  HistoriesEvent.add(
                    history: History(
                      title: data.last,
                      url: data.first,
                    ),
                  ),
                );
              }
            });
          },
          onWebResourceError: (WebResourceError error) {
            //err bloc
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(root));
    super.initState();
  }

  @override
  void dispose() {
    _webViewController.clearCache();
    _webViewController.clearLocalStorage();
    loadingCubit.close();
    historiesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _WebView(
      webViewController: _webViewController,
      loadingCubit: loadingCubit,
      historiesBloc: historiesBloc,
    );
  }
}

class _WebView extends StatelessWidget {
  const _WebView({
    required WebViewController webViewController,
    required this.loadingCubit,
    required this.historiesBloc,
  }) : _webViewController = webViewController;

  final WebViewController _webViewController;
  final LoadingCubit loadingCubit;
  final HistoriesBloc historiesBloc;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // drawer: const CustomDrawer(),
      appBar: _HomeAppBar(
        webViewController: _webViewController,
        height: MediaQuery.of(context).size.height * 0.1,
        bloc: historiesBloc,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _webViewController.reload();
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                WebViewWidget(
                  controller: _webViewController,
                ),
                BlocProvider.value(
                  value: loadingCubit,
                  child: BlocBuilder<LoadingCubit, LoadingState>(
                    builder: (context, state) {
                      if (state.status == LoadingStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({
    required WebViewController webViewController,
    this.height = 100.0,
    required this.bloc,
  }) : _webViewController = webViewController;
  final WebViewController _webViewController;
  final double height;
  final HistoriesBloc bloc;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<HistoriesBloc, HistoriesState>(
        builder: (context, state) {
          return AppBar(
            title: const Text('Wikipedia'),
            actions: [
              IconButton(
                onPressed: () async => _showMyDialog(context, state: state),
                icon: const Icon(Icons.history),
              ),
              _ControlButton(
                type: ControlButtonType.back,
                webViewController: _webViewController,
              ),
              _ControlButton(
                type: ControlButtonType.forward,
                webViewController: _webViewController,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showMyDialog(
    BuildContext context, {
    required HistoriesState state,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          title: Text('visited site'.toCapitalize),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: state.histories.length,
                    itemBuilder: (context, index) {
                      final history =
                          state.histories.toList().reversed.elementAt(index);
                      return ListTile(
                        title: Text(history.title ?? ''),
                        onTap: () {
                          _webViewController
                              .loadRequest(Uri.parse(history.url ?? ''));
                          context.pop();
                        },
                      );
                    },
                    shrinkWrap: true,
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}

enum ControlButtonType { back, forward }

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required WebViewController webViewController,
    required this.type,
  }) : _webViewController = webViewController;

  final ControlButtonType type;
  final WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ControlButtonType.back => IconButton(
          onPressed: () async {
            if (await _webViewController.canGoBack()) {
              _webViewController.goBack();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      _ => IconButton(
          onPressed: () async {
            if (await _webViewController.canGoForward()) {
              _webViewController.goForward();
            }
          },
          icon: const Icon(Icons.arrow_forward),
        )
    };
  }
}
