import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/providers/service_provider.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ServiceStaffDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("buld ServiceStaffDetailPage");
    return Consumer2<ServiceState, UserInfoState>(
      builder: (context, serviceState, userInfoState, child) {
        return FutureBuilder<ServiceStaff>(
            future: serviceState.getSelectedServiceStaff(userInfoState.token),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var serviceStaff = snapshot.data;
                // serviceStaff.isStared = true;
                return Scaffold(
                  appBar: AppBar(
                    title: Text("家政上门"),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 200, color: Colors.red),
                        Container(
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Text(
                                serviceStaff.publicInfo.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              SmoothStarRating(
                                starCount: 5,
                                rating: serviceStaff.score,
                                size: 14,
                              ),
                            ]
                              ..addAll(serviceStaff.tags.map((tag) => Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 0, 2, 2),
                                    child: Badge(
                                      badgeContent: Text(
                                        tag,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      shape: BadgeShape.square,
                                      borderRadius: 4,
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 1, 2, 1),
                                      badgeColor: Theme.of(context).accentColor,
                                    ),
                                  )))
                              ..addAll([
                                Spacer(),
                                Text(
                                  serviceStaff.orderCount.toString() + "单",
                                  style: TextStyle(color: Colors.grey[500]),
                                )
                              ]),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Text("个人简介:${serviceStaff.publicInfo.describe}"),
                            ],
                          ),
                        ),
                        Container(
                          height: 8,
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "评价(0)", //TODO
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Spacer(),
                                  Text(
                                    "查看全部",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 12),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ],
                              ),
                              Container(
                                child: Text("暂无评价"), //TODO
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 8,
                        ),
                        Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text("服务", style: TextStyle(fontSize: 12)),
                              )
                            ]..addAll(serviceStaff.services.map((serviceInfo) =>
                                InkWell(
                                  onTap: () {
                                    serviceState.selectServiceInfo(serviceInfo);
                                  },
                                  child: Container(
                                    child: ListTile(
                                      title: Text(
                                          "[${serviceInfo.service.serviceType.name}]${serviceInfo.service.name}"),
                                      subtitle:
                                          Text(serviceInfo.service.describe),
                                      leading: FlutterLogo(size: 48),
                                      trailing: Text(
                                          "￥${serviceInfo.price.toStringAsFixed(2)}"),
                                    ),
                                    color: serviceState.selectedServiceInfoId ==
                                            serviceInfo.id
                                        ? Colors.grey[100]
                                        : null,
                                  ),
                                ))),
                          ),
                        ),
                        Container(height: 64),
                      ],
                    ),
                  ),
                  bottomNavigationBar: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              serviceState
                                  .starServiceStaff(userInfoState.token);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  serviceStaff.isStared
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: serviceStaff.isStared
                                      ? Theme.of(context).accentColor
                                      : Colors.grey[600],
                                ),
                                Text(
                                  "关注 ${serviceStaff.starCount}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              //TODO
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.grey[600],
                                ),
                                Text(
                                  "聊天",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/createOrder");
                    },
                    child: Icon(Icons.add_shopping_cart),
                    tooltip: "下单",
                  ),
                );
              } else {
                if (snapshot.hasError) print(snapshot.error);
                return Container();
              }
            });
      },
    );
  }
}
