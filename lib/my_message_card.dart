import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

class MyMessageCard extends StatelessWidget {
  MessageModel message ;
   MyMessageCard({
    Key? key,
    required this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(left: 80, top: 15),
      padding:const EdgeInsets.all(15),
      decoration:const BoxDecoration(   
        color: Color.fromARGB(255, 114, 216, 118),   
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20)
        )
      ),
      child: Text('${message.body}' , 
        style:const TextStyle( 
          fontSize: 17 , 
          color: Colors.black
        ),
      ),
    );
  }
}