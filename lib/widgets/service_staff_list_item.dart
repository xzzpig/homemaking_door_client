
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../beans.dart';

class ServiceStaffListItem extends StatelessWidget {
  const ServiceStaffListItem({
    Key key,
    @required this.serviceInfo,
    this.showPrice=true
  }) : super(key: key);

  final ServiceInfo serviceInfo;
  final bool showPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          FlutterLogo(size: 56),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  serviceInfo.serviceStaff.publicInfo.name,
                  style: TextStyle(fontSize: 18),
                ),
                SmoothStarRating(
                  starCount: 5,
                  rating: serviceInfo.serviceStaff.score,
                  size: 10,
                ),
                Row(
                  children: <Widget>[
                    showPrice?Text(
                      "￥" + serviceInfo.price.toStringAsFixed(2),
                      style:
                          TextStyle(fontSize: 16, color: Colors.red),
                    ):Container(),
                    Text(
                      serviceInfo.serviceStaff.orderCount.toString() +
                          "次",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[500]),
                    )
                  ],
                ),
                Row(
                  children: serviceInfo.serviceStaff.tags
                      .map((tag) => Padding(
                            padding:
                                const EdgeInsets.fromLTRB(2, 0, 2, 2),
                            child: Badge(
                              badgeContent: Text(
                                tag,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8),
                              ),
                              shape: BadgeShape.square,
                              borderRadius: 4,
                              padding: const EdgeInsets.fromLTRB(
                                  2, 1, 2, 1),
                              badgeColor:
                                  Theme.of(context).accentColor,
                            ),
                          ))
                      .toList(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
