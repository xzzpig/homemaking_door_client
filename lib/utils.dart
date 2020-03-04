import 'dart:convert';

import 'package:crypto/crypto.dart' as Crypto;
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:homemaking_door/providers/chat_provider.dart';
import 'package:homemaking_door/providers/order_provider.dart';
import 'package:homemaking_door/providers/service_provider.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:provider/provider.dart';

extension StringExt on String {
  String md5() {
    var bytes = utf8.encode(this);
    return Crypto.md5.convert(bytes).toString();
  }

  String join(String str) {
    return this + str;
  }

  dynamic decode() {
    return jsonDecode(this);
  }

  Text toText() => Text(this);

  Text toErrorText() => Text(
        this,
        style: TextStyle(color: Colors.red),
      );
}

extension ObjectExt on Object {
  void println() {
    print(this);
  }
}

extension ListExt<E> on List<E> {
  void forEachIndexed(void f(int index, E element)) {
    int index = 0;
    for (E e in this) {
      f(index, e);
      index++;
    }
  }
}

extension DateTimeExt on DateTime {
  String humanDateTime() {
    return formatDate(this, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
  }

  String humanDate() {
    return formatDate(this, [yyyy, "-", mm, "-", dd]);
  }
}

extension TimeOfDayExt on TimeOfDay {
  String human() {
    return _digits(this.hour, 2) + ":" + _digits(this.minute, 2);
  }
}

extension BuildContextExt on BuildContext {
  UserInfoState get userInfoState =>
      Provider.of<UserInfoState>(this, listen: false);
  ChatState get chatState => Provider.of<ChatState>(this, listen: false);
  OrderState get orderState => Provider.of<OrderState>(this, listen: false);
  ServiceState get serviceState =>
      Provider.of<ServiceState>(this, listen: false);
}

String _digits(int value, int length) {
  String ret = '$value';
  if (ret.length < length) {
    ret = '0' * (length - ret.length) + ret;
  }
  return ret;
}
