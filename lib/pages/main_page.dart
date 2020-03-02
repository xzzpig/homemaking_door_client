import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/chat_list_page.dart';
import 'package:homemaking_door/pages/me_page.dart';
import 'package:homemaking_door/pages/order_list_page.dart';
import 'package:homemaking_door/pages/page.dart';
import 'package:homemaking_door/pages/service_type_page.dart';
import 'package:homemaking_door/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  var _selectedIndex = 0;
  List<MyPage> pages = [
    ServiceTypePage(),
    OrderListPage(),
    ChatListPage(),
    MePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("build main page state");
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: pages[_selectedIndex].appbar(context),
        body: Container(
          child: IndexedStack(
            children: pages,
            index: _selectedIndex,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('服务'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              title: Text('订单'),
            ),
            BottomNavigationBarItem(
              icon: Badge(
                showBadge:
                    Provider.of<ChatState>(context).totalMessageCount != 0,
                child: Icon(Icons.message),
                badgeContent: Text(
                  Provider.of<ChatState>(context).totalMessageCount.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              title: Text('聊天'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('我的'),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 1),
    //     () => Navigator.of(context).pushNamed("/createOrder"));
  }
}
