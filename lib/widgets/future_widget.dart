import 'package:flutter/material.dart';
import 'package:homemaking_door/utils.dart';
import 'package:homemaking_door/widgets/loading_widget.dart';

@immutable
class FutureWidget<T> extends StatelessWidget {
  static Widget defaultErrorBuilder(BuildContext buildContext, Object error) {
    return error.toString().toErrorText();
  }

  // static const Widget Function(BuildContext,Object) errorBuilders
  final Future<T> future;
  final Widget Function(BuildContext, T) builder;
  final Widget Function(BuildContext, Object) errorBuilder;

  FutureWidget(
      {this.future,
      @required this.builder,
      this.errorBuilder = defaultErrorBuilder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return builder(context, snapshot.data);
          } else if (snapshot.hasError) {
            return errorBuilder(context, snapshot.error);
          } else {
            return Loading();
          }
        });
  }
}
