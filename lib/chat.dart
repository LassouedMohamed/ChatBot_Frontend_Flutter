import 'dart:async';

import 'package:chat_app/conversation.dart';
import 'package:chat_app/friend_message_card.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/my_message_card.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/conversation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/conversations_model.dart';



class Chat extends StatefulWidget {
    final ConversationModel conversation;
  Chat({ Key? key , required this.conversation}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<MessageModel> _conversation =[];
  final ScrollController _scrollController = ScrollController();
  late MessageModel message ;
  List<MessageModel> _conversationsUpdated =[];
  bool isReelTime = false ;
  var _timer;
  String? _token;
  @override
  void initState() {
    
    message =MessageModel(createdAt: "", updatedAt : "");
    message.conversationId =  widget.conversation.id;
    
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp)async{
        _token = await Provider.of<AuthProvider>(context , listen: false).tokens;
        if(mounted){
        _timer=Timer.periodic(const Duration(seconds: 1), realTimeConversations) ;
        }
      });
    
    super.initState();
    //notification
    // NotificationApiModel.init();
    // listenNotifications();
  }
//-----------notification
// void listenNotifications() =>NotificationApiModel.onNotifications.stream.listen(onClickedNotification);

// void onClickedNotification(String? payload)=> print('new pasge  $payload');
//--------------------------------
  
  
  final TextEditingController _messageController = TextEditingController();


  realTimeConversations(Timer t){
    List<ConversationModel> _conv=Provider.of<ConversationProvider>(context , listen: false).conversations;
    var conversationsUpdated = _conv.firstWhere((element) => element.id == widget.conversation.id) ;
    setState(() {
      _conversationsUpdated=conversationsUpdated.messages.reversed.toList();
    });
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent );
  }
  @override
  void dispose() {
    _timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _conversation = _conversationsUpdated;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon:const Icon(Icons.arrow_back_ios),
        ),
        title: Text('${widget.conversation.user!.name}'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:_conversation.isEmpty? Center(child: Text("Loading ...")):ListView.builder(
                controller: _scrollController,
                itemCount: _conversation.length,
                itemBuilder: (context,index)=> _conversation[index].userId == widget.conversation.user!.id ?
                FriendMessageCard(message : _conversation[index])  : MyMessageCard(message : _conversation[index]) 
                ),
            ),
            ),
          Container(
            padding:const EdgeInsets.all(12),
            margin:const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius:  BorderRadius.circular(15),
              border: Border.all(
                    color: Colors.grey,
                    width: 2)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'message ...'
                    ),
                  )
                ),
                Container(
                  padding:const EdgeInsets.all(6),
                  decoration:const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF4382d8),Color(0xFF2facd6),Color(0xFF2facd6),Color(0xFF2facd6),Color(0xFF2facd6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                  child:InkWell(
                    onTap: () async{
                      if(_messageController.text.trim().isEmpty) return ;
                      message.body = _messageController.text.trim();
                      await Provider.of<ConversationProvider>(context, listen: false).sendMessages(message,_token);                    
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent +50 );
                      _messageController.clear();
                      // NotificationApiModel.showNotification(
                      //   title: '${widget.conversation.user!.name}',
                      //   body: '${_messageController.text.trim()}',
                      //   payload: 'transferer vers conversation'
                      // );
                    },
                    child: const Icon(
                      Icons.send ,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
