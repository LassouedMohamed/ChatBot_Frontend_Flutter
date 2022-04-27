import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';


class ConversationModel {
  int? id;
  UserModel? user;
  String? createdAt;
  List<MessageModel> messages =[];

  ConversationModel({this.id, this.user,  this.createdAt, required this.messages});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    
    user = json['user'] != null ?UserModel.fromJson(json['user']) : null;
    
    createdAt = json['created_at'].toString();  
     
    if(json['messages'] !=null){
      for(var element in json['messages']){
        messages.add(MessageModel.fromJson(element));
      }
    }  
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['created_at'] = createdAt;
    if (messages != null) {
      data['messages'] = messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}