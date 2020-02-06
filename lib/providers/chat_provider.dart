import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:homemaking_door/beans.dart';

class ChatState with ChangeNotifier {
  var _totalMessageCount = 5;
  int get totalMessageCount => _totalMessageCount;

  List<ChatPreview> get chatPreviews => [
        ChatPreview(PublicUser(nickName: "aaa"), DateTime.now(), "bbb",1),
        ChatPreview(PublicUser(nickName: "aaa"), DateTime.now(), "bbb",2),
        ChatPreview(PublicUser(nickName: "aaa"), DateTime.now(), "bbb",3),
        ChatPreview(PublicUser(nickName: "aaa"), DateTime.now(), "bbb",0),
      ];
}
