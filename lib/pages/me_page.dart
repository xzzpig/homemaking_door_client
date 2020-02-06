
import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/page.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MePage extends StatelessWidget with MyPage{
  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoState>(builder: (context, userinfo, child) {
      if(userinfo==null)return Container();
      var info = userinfo.info;
      return Column(children: <Widget>[
            InkWell(child: ListTile(leading: FlutterLogo(size: 56,),title: Text(info.nickName),subtitle: Text(info.describe),),onTap: () {},),
            InkWell(child: ListTile(title:Text("我的关注"),trailing: Icon(Icons.arrow_forward_ios,size: 16,),),onTap: (){},),
            InkWell(child: ListTile(title:Text("软件设置"),trailing: Icon(Icons.arrow_forward_ios,size: 16,),),onTap: (){},),
            InkWell(child: ListTile(title:Text("问题反馈"),trailing: Icon(Icons.arrow_forward_ios,size: 16,),),onTap: (){},),
            InkWell(child: ListTile(title:Text("关于"),trailing: Icon(Icons.arrow_forward_ios,size: 16,),),onTap: (){},),
          ],);
    },);
  }
}