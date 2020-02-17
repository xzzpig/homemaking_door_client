import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';

class OrderListItem extends StatelessWidget {
  final Order order;
  final Iterable<Widget> extras;
  const OrderListItem({Key key, this.order,this.extras=const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(
                child: Text(
              order.serviceInfo.service.name,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            )),
            Text(
              order.humanState,
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 12),
            ),
          ]),
          Row(
            children: <Widget>[
              Icon(
                Icons.ac_unit,
                size: 48,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(order.staff.publicInfo.name),
                      Text(
                        order.humanTime,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "服务地点",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(4),
                ),
              ),
              Text("￥${order.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 15)),
            ],
          ),
         ]..addAll(extras),
      ),
      padding: EdgeInsets.all(8),
    );
  }
}
