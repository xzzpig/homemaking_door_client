import 'package:time_ago_provider/time_ago_provider.dart';

class ChatPreview {
  PublicUser target;
  DateTime time;
  String preview;
  int messageCount;

  String get humanMessageCount=> messageCount>99?"99+":messageCount.toString();
  String get timeago => TimeAgo.getTimeAgo(time.millisecondsSinceEpoch,language: Language.CHINESE);

  ChatPreview(this.target,this.time,this.preview,this.messageCount);
}

class Location {
  int id;
  String province;
  String city;
  String district;
  Location(this.id,this.province,this.city,this.district);
}

class PublicUser {
  int id;
  String name;
  String userName;
  String nickName;
  String sex;
  String describe;
  String headImage;
  Location location;
  PublicUser({this.id,this.name,this.userName,this.nickName,this.sex,this.describe,this.headImage,this.location});
}

class Service {
  int id;
  String name;
  String describe;
  ServiceType serviceType;
  String icon;
  Service({this.id, this.name, this.describe, this.serviceType, this.icon});
}

class ServiceType {
  int id;
  String name;
  ServiceType(this.id, this.name);
}
