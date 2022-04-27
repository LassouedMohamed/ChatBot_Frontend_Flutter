import 'dart:ui';

import 'package:chat_app/models/conversations_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
// ignore: must_be_immutable
class ConversationCard extends StatelessWidget {
  VoidCallback onTapConversation;
  ConversationModel conversation ;
   ConversationCard({
    Key? key, 
    required this.onTapConversation,
    required this.conversation,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    int? idUser = Provider.of<AuthProvider>(context, listen: false).user?.id;
    return ListTile(
      onTap: onTapConversation,
      leading:const CircleAvatar(backgroundColor: Colors.amber),
      title: conversation.user !=null? Text("${conversation.user?.name}" ,style: TextStyle(
        color: Colors.black87
      ),):  null,
      subtitle: conversation.messages.isNotEmpty? Text("${conversation.messages.reversed.toList().last.body }", style: TextStyle(
        color: conversation.messages.reversed.toList().last.userId == idUser ?Colors.grey : conversation.messages.reversed.toList().last.read.toString() == '1' ? Colors.grey :Colors.black 
      ),):  null,
      trailing: conversation.messages.isNotEmpty? Text("${timeago.format( DateTime.parse(conversation.messages.reversed.toList().last.createdAt.toString()) )}" , style: TextStyle(
                color: conversation.messages.reversed.toList().last.userId == idUser ?Colors.grey : conversation.messages.reversed.toList().last.read.toString() == '1' ? Colors.grey :Colors.black 
      ),):  null,
    );
      
  }
}