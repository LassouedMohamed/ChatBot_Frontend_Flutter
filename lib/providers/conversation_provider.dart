import 'dart:convert';
import 'package:chat_app/models/conversations_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/services/conversations_service.dart';
import 'package:flutter/cupertino.dart';

class ConversationProvider extends ChangeNotifier {
  AuthProvider _authProvider = AuthProvider();
  ConversationService _conversationService = ConversationService();

  List<ConversationModel> _conversations = [];
  
  bool _busy = false;

  List<ConversationModel> get conversations => _conversations;

  bool get busy =>_busy;

  setBusy(bool val){
    _busy = val ;
    notifyListeners();
  }

  Future <List<ConversationModel>> getConversation(String? token) async{
    Map<String, dynamic> mapData = {};
    List  ListData = [];
    setBusy(true);
    http.Response response = await _conversationService.getConversations(token);
    
    if(response.statusCode ==200){
      try{
        mapData = jsonDecode(response.body);
        ListData = mapData['data'];
        if(_conversations.isNotEmpty){
          
          if(ListData.length == _conversations.length){ 
            _conversations=[];
            for (var element in ListData) {
              _conversations.add(ConversationModel.fromJson(element)); 
            }
          }else{
            _conversations=[];
            for (var element in ListData) {
              _conversations.add(ConversationModel.fromJson(element)); 
            }
          }
        }else{     
            
        for (var element in ListData) {
          _conversations.add(ConversationModel.fromJson(element));
        }
        }
        notifyListeners();
        setBusy(false);
      }catch(e){
        print(e);
      }
    }
    setBusy(false);
    return _conversations;
  }

  Future<void> sendMessages(MessageModel message , String? token)async{
    setBusy(true);
    http.Response response = await _conversationService.sendMessage(message, token);
    if( response.statusCode ==201){
      var data = jsonDecode(response.body);
      setBusy(false);
      addMessageToConversation(int.parse(message.conversationId.toString()), MessageModel.fromJson(data['data']));
    }
    setBusy(false);
   
  }

  addMessageToConversation(int conversationId , MessageModel message){
    var conversation = _conversations
    .firstWhere((element) => element.id == conversationId);
    conversation.messages.add(message);
    toTheTop(conversation);
    notifyListeners();
  }

  toTheTop(ConversationModel conversation){
    var index = _conversations.indexOf(conversation);
    for(var i = index ; i>0 ; i--){
      var x = _conversations[i];
      _conversations[i] = _conversations[i-1];
      _conversations[i-1]=x;
    }
  }

  Future<void>makeConversationAsReaded(int? idConversation,String? token)async{
    http.Response response = await _conversationService.makeConversationRead(idConversation,token);
    if( response.statusCode ==200){
      try{
        var data = jsonDecode(response.body);
        print("$data");
      }catch(e){
        print("$e");
      }
    }
  }

  Future addConversation(token ,id)async{
    try{
      http.Response response = await _conversationService.addConversation(token, id);
      if(response.statusCode==200){
        var data = jsonDecode(response.body);
        print("${data['data']}");
      }
      if(response.statusCode==201){
        var data = jsonDecode(response.body);
        print("${data['data']}");
      }
    }catch(_){

    }

  }

}