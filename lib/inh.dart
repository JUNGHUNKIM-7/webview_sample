import 'package:flutter/material.dart';

enum Location {
  sf(pos: 0);

  final int pos;

  const Location({required this.pos});
}

class Configs extends InheritedWidget {
  const Configs({
    required List<Object> children,
    required super.child,
    super.key,
  }) : _children = children;

  final List<Object> _children;

  static Configs? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Configs>();
  }

  static T of<T>(BuildContext context, {required Location loc}) {
    final Configs? result = maybeOf(context);
    assert(result != null, 'No configs found in context');
    return result!._children[loc.pos] as T;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      child != oldWidget.child;
}
