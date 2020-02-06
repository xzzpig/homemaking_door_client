import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

mixin MyPage on Widget{
  PreferredSizeWidget appbar(BuildContext context) => AppBar(
    title: Text("家政上门"),
  );
}
