import 'dart:async';

import 'package:chat_app/chat.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/conversation_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'conversation_card.dart';
class Conversation extends StatefulWidget {

  const Conversation({ Key? key }) : super(key: key);

  @override



  State<Conversation> createState() 
  => _ConversationState();
}



class _ConversationState extends State<Conversation> {
  var _timer;
  @override
  String? token;
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_)async{
      token = await Provider.of<AuthProvider>(context , listen: false).tokens;
      
      if(mounted){
      _timer = Timer.periodic(const Duration(seconds: 1), updateConversation);
    }
    });    
  }

  updateConversation(Timer t){
   Provider.of<ConversationProvider>(context , listen: false).getConversation(token);
  }
   
 
  @override
  Widget build(BuildContext context) {
     
    var provider = Provider.of<ConversationProvider>(context , listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){},
          icon: const Icon(Icons.search) ),
      ),
      body:ListView.builder(
          shrinkWrap:true,
          itemCount: provider.conversations.length,
          itemBuilder: (context , index){
            return ConversationCard(
              conversation: provider.conversations[index],
              onTapConversation :(){Navigator.push(context ,MaterialPageRoute(
                builder: (context)=> Chat(conversation:provider.conversations[index])
                )
              );               
              }              
            );
          },
        )
    );
  }
}

