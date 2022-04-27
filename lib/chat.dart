import 'dart:async';

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
  int? idUser;
  List<MessageModel> _conversation =[];
  late MessageModel message ;
  List<MessageModel> _conversationsUpdated =[];
  bool isReelTime = false ;
  var _timer;
  final ScrollController _scrollController = ScrollController();
  String? _token;
  @override
  void initState() {
    
    message =MessageModel();
    message.conversationId =  widget.conversation.id;
    
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp)async{
        _token = await Provider.of<AuthProvider>(context , listen: false).tokens;
        idUser = await Provider.of<AuthProvider>(context, listen: false).user?.id;
        if(mounted){
        _timer=Timer.periodic(const Duration(seconds: 1), realTimeConversations) ;
        Future.delayed(const Duration(seconds: 2), (){
          if(_scrollController.positions.isNotEmpty){
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
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


  realTimeConversations(Timer t)async{
    List<ConversationModel> _conv= await Provider.of<ConversationProvider>(context , listen: false).conversations;
    var conversationsUpdated = _conv.firstWhere((element) => element.id == widget.conversation.id) ;
    setState(() {
      _conversationsUpdated=conversationsUpdated.messages.reversed.toList();
    });
    if(_scrollController.positions.isNotEmpty){
      if(_scrollController.position.pixels ==_scrollController.position.maxScrollExtent){
        if(_conversationsUpdated.last.read.toString()=='0'){
          if(_conversationsUpdated.last.userId != idUser){
            Provider.of<ConversationProvider>(context , listen: false).makeConversationAsReaded(_conversationsUpdated.last.conversationId, _token);
          }
        }
      }

    }
  }
  @override
  void dispose() {
    _timer.cancel();
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
              child:_conversation.isEmpty? Container():ListView.builder(
                controller: _scrollController,
                itemCount: _conversation.length,
                itemBuilder: (context,index){
                  return _conversation[index].userId != idUser ?
                  FriendMessageCard(message : _conversation[index])  : MyMessageCard(message : _conversation[index]) ;
                }
              ),
            ),
          ),
          _conversation.isEmpty? Container():
          _conversation.last.read=='1'? Container():
          _conversation.last.userId == idUser ? Container():
          _scrollController.positions.isEmpty ? Container():
          _scrollController.position.pixels +15 >= _scrollController.position.maxScrollExtent ?
          Container() :
          InkWell(
            onTap: ()async{
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              await Provider.of<ConversationProvider>(context , listen: false).makeConversationAsReaded(_conversation.last.conversationId, _token);
               
            },
            child: Container(
              width: 250,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow:const [
                  BoxShadow(
                    color: Color.fromARGB(255, 92, 209, 230),
                    blurRadius: 10,
                    offset: Offset(1, 1), // Shadow position
                  ),
                ],
              ),
              child: Center(child: Text("${_conversation.last.body} ")
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
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent+15);
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
