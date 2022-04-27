import 'package:http/http.dart' as http;


import '../models/message_model.dart';
class ConversationService {
  Future <http.Response> getConversations(String? token) async{
    
      http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/conversation'),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'
      });

      return response;

    
  }

  Future <http.Response> addConversation(token , id)async{
    
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
    
  }

  Future <http.Response> sendMessage(MessageModel message , String? token)async{
    
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

  }

  Future <http.Response> makeConversationRead(int? idConversation,String? token)async{
    

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

    
  }

}