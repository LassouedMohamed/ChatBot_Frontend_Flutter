
import 'dart:convert';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';

class ConversationModel {
  int? id;
  UserModel? user;
  late String createdAt;
  List<MessageModel> messages =[];

  ConversationModel({this.id, this.user, required this.createdAt, required this.messages});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    createdAt = json['created_at'];    
    json['messages'].forEach((element) {
        messages.add(MessageModel.fromJson(element));
      });   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['created_at'] = this.createdAt;
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}