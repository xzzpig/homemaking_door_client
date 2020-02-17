import 'package:date_format/date_format.dart';
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

class Address{
  int id;
  Location location;
  String detail;
  PublicUser user;
  Address({this.id,this.location,this.detail,this.user});
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

class ServiceInfo{
  int id;
  Service service;
  double price;
  ServiceStaff serviceStaff;
  ServiceInfo({this.id,this.service,this.price,this.serviceStaff});
}

class ServiceStaff{
  int id;
  PublicUser publicInfo;
  double score;
  List<String> tags;
  int orderCount;
  int starCount;
  String photo;
  List<ServiceInfo> services;
  List<Assessment> assessments;
  bool isStared;
  ServiceStaff({this.id,this.publicInfo,this.score,this.tags,this.orderCount,this.starCount,this.isStared,this.photo,this.services,this.assessments});
}

class Assessment{
  int id;
  PublicUser user;
  int score;
  String detail;
  int time;
  Order order;
  ServiceStaff serviceStaff;
  Assessment({this.id,this.user,this.score,this.detail,this.time,this.order,this.serviceStaff});
}

class Order{
  int id;
  PublicUser user;
  ServiceStaff staff;
  int state;
  ServiceInfo serviceInfo;
  double price;
  DateTime time;
  Address address;
  Map form;
  bool userConfirm;
  bool staffConfirm;
  Order({this.id,this.user,this.staff,this.state,this.serviceInfo,this.price,this.time,this.address,this.form,this.userConfirm,this.staffConfirm});
  String get humanState=>const ["待确认","待上门","待评价","已完成"][state];
  String get humanTime=>formatDate(time,[yyyy,"-",mm,"-",dd," ",HH,":",nn]);
}