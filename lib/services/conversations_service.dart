import 'package:http/http.dart' as http;


import '../models/message_model.dart';
class ConversationService {
  Future getConversations(String? token) async{
    try{
      http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/conversation'),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'
      });

      return response;

    }catch(_){
      
    }
  }

  Future addConversation(token , id)async{
    try{
      http.Response response =await http.post(
        Uri.parse('http://10.0.2.2:8000/api/conversation'),
          headers: {
            'Authorization' : 'Bearer $token',
            'Accept' : 'application/json'
            },
            body: {
              'user_id' : id.toString(),
            }
        ) ;

      return response;
    }catch(_){

    }
  }

  Future sendMessage(MessageModel message , String? token)async{
    try{
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/message"),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'
        },
        body: {
          'body' : message.body ,
          'conversation_id' : message.conversationId.toString(),

        }
        );
      return response;

    }catch(_){
      
    }
  }

  Future makeConversationRead(int? idConversation,String? token)async{
    try{

      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/conversation/read"),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'
        },
        body: {
          'conversation_id' : idConversation.toString()
        }
      );

      return response;

    }catch(_){
      
    }
  }

}