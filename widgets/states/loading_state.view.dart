import 'package:flutter/material.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.child, this.loading, Key key}) : super(key: key);

  final Widget child;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return loading ? BusyIndicator().centered().p4(): child;
  }
}
