import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homemaking_door/pages/order_assess_page.dart';
import 'package:time_ago_provider/time_ago_provider.dart';
import 'package:homemaking_door/utils.dart';

class ChatPreview {
  PublicUser target;
  DateTime time;
  String preview;
  int messageCount;

  String get humanMessageCount =>
      messageCount > 99 ? "99+" : messageCount.toString();
  String get timeago => TimeAgo.getTimeAgo(time.millisecondsSinceEpoch,
      language: Language.CHINESE);

  ChatPreview(this.target, this.time, this.preview, this.messageCount);
  ChatPreview.fromDynamic(dynamic data); //TODO
}

class Region {
  int id;
  String name;
  Region parent;
  String sname;
  int level;
  String citycode;
  String yzcode;
  String mername;
  double lng;
  double lat;
  String pinyin;
  List<Region> children;
  Region(
      {this.id,
      this.name,
      this.parent,
      this.sname,
      this.children,
      this.citycode,
      this.lat,
      this.level,
      this.lng,
      this.mername,
      this.pinyin,
      this.yzcode});
  Region.fromDynamic(dynamic data) {
    if (data == null) return;
    this.id = data["id"];
    this.name = data["name"];
    this.parent = Region.fromDynamic(data["parent"]);
    this.sname = data["sname"];
    this.children = (data["children"] as List<dynamic>)
        ?.map((e) => Region.fromDynamic(e))
        ?.toList();
    this.citycode = data["citycode"];
    this.lat = data["lat"];
    this.level = data["level"];
    this.lng = data["lng"];
    this.mername = data["mername"];
    this.pinyin = data["pinyin"];
    this.yzcode = data["yzcode"];
  }
}

class Address {
  int id;
  Region region;
  String detail;
  PublicUser user;
  bool isDefault;

  Address({this.id, this.region, this.detail, this.user, this.isDefault});
  Address.fromDynamic(dynamic data) {
    if (data == null) return;
    this.id = data["id"];
    this.region = Region.fromDynamic(data["region"]);
    this.detail = data["detail"];
    this.user = PublicUser.fromDynamic(data["user"]);
    this.isDefault = data["isDefault"];
  }
}

class PublicUser {
  int id;
  String name;
  String userName;
  String nickName;
  bool sex;
  String describe;
  String headImage;
  Region region;
  PublicUser(
      {this.id,
      this.name,
      this.userName,
      this.nickName,
      this.sex,
      this.describe,
      this.headImage,
      this.region});
  PublicUser.fromDynamic(dynamic data) {
    if (data == null) return;
    this.id = data["id"];
    this.name = data["name"];
    this.userName = data["userName"];
    this.nickName = data["nickName"];
    this.sex = data["sex"];
    this.describe = data["describe"];
    this.headImage = data["headImage"];
    this.region = Region.fromDynamic(data["region"]);
  }
}

class Service {
  int id;
  String name;
  String describe;
  ServiceType serviceType;
  String icon;
  int staffCount;
  List<ServiceFormDefine> formDefines;
  Service(
      {this.id,
      this.name,
      this.describe,
      this.serviceType,
      this.icon,
      this.staffCount,
      this.formDefines});
  Service.fromDynamic(dynamic data) {
    if (data == null) return;
    this.id = data["id"];
    this.name = data["name"];
    this.describe = data["describe"];
    this.serviceType = ServiceType.fromDynamic(data["serviceType"]);
    this.icon = data["icon"];
    this.staffCount = data["staffCount"];
    this.formDefines = (data["formDefines"] as List<dynamic>)
        ?.map((e) => ServiceFormDefine.fromDynamic(e))
        ?.toList();
  }
  @override
  String toString() {
    return "Service($id,$name)";
  }
}

class ServiceFormDefine {
  int id;
  String key;
  String describe;
  int type;
  Service service;
  ServiceFormDefine(this.id, this.key, this.describe, this.type, this.service);
  ServiceFormDefine.fromDynamic(dynamic data) {
    if (data == null) return;
    this.id = data["id"];
    this.key = data["key"];
    this.describe = data["describe"];
    this.type = data["type"];
    this.service = Service.fromDynamic(data["service"]);
  }
}

class ServiceType {
  int id;
  String name;
  ServiceType(this.id, this.name);
  ServiceType.fromDynamic(dynamic data) {
    if (data == null) return;
    this.id = data["id"];
    this.name = data["name"];
  }
  @override
  String toString() {
    return "ServiceType($id:$name)";
  }
}

class ServiceInfo {
  int id;
  Service service;
  double price;
  ServiceStaff serviceStaff;

  ServiceInfo({this.id, this.service, this.price, this.serviceStaff});
  ServiceInfo.fromDynamic(dynamic data) {
    if (data == null) return;
    this.id = data["id"];
    this.service = Service.fromDynamic(data["service"]);
    this.price = data["price"];
    this.serviceStaff = ServiceStaff.fromDynamic(data["serviceStaff"]);
  }
}

class ServiceStaff {
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
  ServiceStaff(
      {this.id,
      this.publicInfo,
      this.score,
      this.tags,
      this.orderCount,
      this.starCount,
      this.isStared,
      this.photo,
      this.services,
      this.assessments});
  ServiceStaff.fromDynamic(dynamic data) {
    if (data == null) return;
    this.id = data["id"];
    this.publicInfo = PublicUser.fromDynamic(data["publicInfo"]);
    this.score = data["score"];
    this.tags =
        (data["tags"] as List<dynamic>)?.map((e) => e.toString())?.toList();
    this.orderCount = data["orderCount"];
    this.starCount = data["starCount"];
    this.isStared = data["isStared"];
    this.photo = data["photo"];
    this.services = (data["services"] as List<dynamic>)
        ?.map((e) => ServiceInfo.fromDynamic(e))
        ?.toList();
    this.assessments = (data["assessments"] as List<dynamic>)
        ?.map((e) => Assessment.fromDynamic(e))
        ?.toList();
    this.isStared = data["isStared"];
  }

  void changeStared() {
    if (isStared)
      starCount--;
    else
      starCount++;
    isStared = !isStared;
  }
}

class Assessment {
  int id;
  PublicUser user;
  int score;
  String detail;
  int time;
  Order order;
  ServiceStaff serviceStaff;
  Assessment(
      {this.id,
      this.user,
      this.score,
      this.detail,
      this.time,
      this.order,
      this.serviceStaff});
  Assessment.fromDynamic(dynamic data); //TODO
}

class OrderAction {
  static String ORDER_CANCEL = "ORDER_CANCEL";
  static String ORDER_MODIFY = "ORDER_MODIFY";
  static String ORDER_CONFIRM = "ORDER_CONFIRM";
  static String DOOR_CONFIRM = "DOOR_CONFIRM";
  static String ORDER_ASSESS = "ORDER_ASSESS";
  static Map<String, OrderAction> actions = {
    ORDER_CANCEL: OrderAction(ORDER_CONFIRM, "取消订单", (context, order) {
      print("a");
      //TODO
    }),
    ORDER_MODIFY: OrderAction(ORDER_CONFIRM, "修改订单", (context, order) {
      print("b");
      //TODO
    }),
    ORDER_CONFIRM: OrderAction(ORDER_CONFIRM, "确认订单", (context, order) {
      var userInfoState = context.userInfoState;
      var orderState = context.orderState;
      orderState.confirmOrder(userInfoState.token, order.id).then((value) {
        Scaffold.of(context).showSnackBar(SnackBar(content: "订单确认成功".toText()));
      }).catchError(print);
    }),
    DOOR_CONFIRM: OrderAction(DOOR_CONFIRM, "确认上门", (context, order) {
      var userInfoState = context.userInfoState;
      var orderState = context.orderState;
      orderState.confirmDoor(userInfoState.token, order.id).then((value) {
        Scaffold.of(context).showSnackBar(SnackBar(content: "上门确认成功".toText()));
      }).catchError(print);
    }),
    ORDER_ASSESS: OrderAction(ORDER_ASSESS, "评价", (context, order) {
      Navigator.of(context).pushNamed(OrderAssessPage.routeName,
          arguments: OrderAssessPageRouteArguments(order.id));
    }),
  };

  String name;
  String displayName;
  void Function(BuildContext, Order) action;
  OrderAction(this.name, this.displayName, this.action);
}

class Order {
  int id;
  PublicUser user;
  ServiceStaff staff;
  int state;
  ServiceInfo serviceInfo;
  double price;
  DateTime time;
  Address address;
  dynamic form;
  bool userConfirm;
  bool staffConfirm;
  List<String> actions;

  Order(
      {this.id,
      this.user,
      this.staff,
      this.state,
      this.serviceInfo,
      this.price,
      this.time,
      this.address,
      this.form,
      this.userConfirm,
      this.staffConfirm});
  Order.fromDynamic(dynamic data) {
    if (data == null) return;
    this.id = data["id"];
    this.user = PublicUser.fromDynamic(data["user"]);
    this.staff = ServiceStaff.fromDynamic(data["staff"]);
    this.state = data["state"];
    this.serviceInfo = ServiceInfo.fromDynamic(data["serviceInfo"]);
    this.price = data["price"];
    this.time = data["time"] != null
        ? DateTime.fromMillisecondsSinceEpoch(data["time"])
        : null;
    this.address = Address.fromDynamic(data["address"]);
    this.form = (data["form"] as String)?.decode();
    this.userConfirm = data["userConfirm"];
    this.staffConfirm = data["staffConfirm"];
    this.actions =
        (data["actions"] as List<dynamic>)?.map((e) => e.toString())?.toList();
  }
  String get humanState =>
      (state == 0 && userConfirm == true && staffConfirm == false)
          ? "待对方确认"
          : const ["待确认", "待上门", "待评价", "已完成"][state];
  String get humanTime => time.humanDateTime();
}

class AuthUser {
  PublicUser info;
  List<Address> addresses;
  Address defaultAddress;
  String phone;
  AuthUser({this.info, this.addresses, this.defaultAddress, this.phone});
  AuthUser.fromDynamic(dynamic data) {
    if (data == null) return;
    this.info = PublicUser.fromDynamic(data["info"]);
    this.addresses = (data["addresses"] as List<dynamic>)
        ?.map((e) => Address.fromDynamic(e))
        ?.toList();
    this.defaultAddress = Address.fromDynamic(data["defaultAddress"]);
    this.phone = data["phone"];
  }
}
