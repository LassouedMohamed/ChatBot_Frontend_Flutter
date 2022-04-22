import 'package:chat_app/models/conversations_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart' ;

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
    return ListTile(
      onTap: onTapConversation,
      leading: CircleAvatar(backgroundColor: Colors.amber),
      title: conversation.user !=null? Text("${conversation.user?.name}"):  null,
      subtitle: conversation.messages.isNotEmpty? Text("${conversation.messages.reversed.toList().last.body}"):  null,
      trailing: conversation.messages.isNotEmpty? Text(timeago.format(DateTime.parse(conversation.messages.reversed.toList().last.createdAt.toString()) )):  null,
    );
      
  }
}