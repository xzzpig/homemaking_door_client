import 'dart:convert';

import 'package:crypto/crypto.dart' as Crypto;
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

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

String _digits(int value, int length) {
  String ret = '$value';
  if (ret.length < length) {
    ret = '0' * (length - ret.length) + ret;
  }
  return ret;
}
