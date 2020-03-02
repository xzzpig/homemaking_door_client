import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';

class OrderActions extends StatelessWidget {
  final Order order;

  const OrderActions(
    this.order, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: order.actions.map((action) {
        var actionObj = OrderAction.actions[action];
        return Container(
          child: OutlineButton(
            onPressed: () {
              actionObj.action(context);
            },
            child: Text(
              actionObj.displayName,
              style: TextStyle(fontSize: 12),
            ),
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          height: 24,
          width: 72,
          padding: EdgeInsets.only(left: 4),
        );
      }).toList(),
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
