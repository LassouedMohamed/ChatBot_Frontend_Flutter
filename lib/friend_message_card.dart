import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';


class FriendMessageCard extends StatelessWidget {
  MessageModel message ;
  FriendMessageCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      decoration:const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4382d8),Color(0xFF2facd6),Color(0xFF2facd6),Color(0xFF2facd6),Color(0xFF2facd6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20)
        )
      ),
      child:Text('${message.body}' , 
        style: TextStyle( 
          fontSize: 17 , 
          color: Colors.white
        ),
      ),
    );
  }
}


