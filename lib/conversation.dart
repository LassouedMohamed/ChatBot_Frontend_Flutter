import 'dart:async';

import 'package:chat_app/add_conversation.dart';
import 'package:chat_app/chat.dart';
import 'package:chat_app/login.dart';
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
  
  String? token;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_)async{
      token = await Provider.of<AuthProvider>(context , listen: false).tokens;
      await Provider.of<ConversationProvider>(context , listen: false).getConversation(token);
      if(mounted){
      _timer = Timer.periodic(const Duration(seconds: 1), updateConversation);
    }
    });    
  }

  updateConversation(Timer t){
   Provider.of<ConversationProvider>(context , listen: false).getConversation(token);
  }
  @override 
 void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     
    var provider = Provider.of<ConversationProvider>(context , listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        centerTitle: true,
        leading: IconButton(
          onPressed: ()async{
            await Provider.of<AuthProvider>(context , listen: false).logout();
            Navigator.push(context ,MaterialPageRoute(
              builder: (context)=> Login()
              ));   
          },
          icon: const Icon(Icons.logout) ),
          actions: [
            IconButton(
              icon:const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context ,MaterialPageRoute(
              builder: (context)=> AddConversations()
              ));  
              },
            )
          ],
      ),
      body:ListView.builder(
        shrinkWrap:true,
        itemCount: provider.conversations.length,
        itemBuilder: (context , index){
          return ConversationCard(
            conversation: provider.conversations[index],
            onTapConversation :(){Navigator.push(context ,MaterialPageRoute(
              builder: (context)=> Chat(conversation:provider.conversations[index])
              ));               
            }              
          );
        },
      )
    );
  }
}

