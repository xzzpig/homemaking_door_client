import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/page.dart';
import 'package:homemaking_door/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatelessWidget with MyPage {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatState>(
      builder: (context, chatState, child) {
        var chatPreviews = chatState.chatPreviews;
        return ListView.builder(
          itemBuilder: (context, index) {
            var chatPreview = chatPreviews[index];
            return Column(
              children: <Widget>[
                InkWell(
                  child: ListTile(
                    title: Text(chatPreview.target.nickName),
                    subtitle: Text(chatPreview.preview),
                    leading: FlutterLogo(
                      size: 56,
                    ),
                    trailing: Column(
                      children: <Widget>[
                        Text(
                          chatPreview.timeago,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Spacer(),
                        Badge(
                          badgeContent: Text(
                            chatPreview.humanMessageCount,
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          borderRadius: 20,
                          shape: BadgeShape.square,
                          padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                          showBadge: chatPreview.messageCount != 0,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                onTap: () {
                  
                },
                ),
                Container(height: 1,color: Colors.grey[300],margin: EdgeInsets.fromLTRB(8, 0, 8, 0),)
              ],
            );
          },
          itemCount: chatPreviews.length,
        );
      },
    );
  }
}
