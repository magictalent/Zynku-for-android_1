import 'package:flutter/material.dart';

T createModel<T>(BuildContext context, T Function() modelBuilder) =>
    modelBuilder();

extension NavContext on BuildContext {
  void pushNamed(String routeName) {
    Navigator.pushNamed(this, routeName);
  }
}

extension StateExtension on State {
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }
}

extension WidgetExtension on Widget {
  Widget responsiveVisibility({
    bool mobile = true,
    bool tablet = true,
    bool desktop = true,
  }) {
    return this;
  }
}
