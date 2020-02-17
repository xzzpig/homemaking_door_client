
import 'package:flutter/material.dart';

class OrderActions extends StatelessWidget {
  const OrderActions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: OutlineButton(
            onPressed: () {},
            child: Text("取消订单",style: TextStyle(fontSize: 12),),
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          height: 24,
          width: 72,
          padding: EdgeInsets.only(left: 4),
        ),
        Container(
          child: OutlineButton(
            onPressed: () {},
            child: Text("修改订单",style: TextStyle(fontSize: 12),),
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          height: 24,
          width: 72,
          padding: EdgeInsets.only(left: 4),
        ),
        Container(
          child: OutlineButton(
            onPressed: () {},
            child: Text("确认",style: TextStyle(fontSize: 12),),
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          height: 24,
          width: 72,
          padding: EdgeInsets.only(left: 4),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
