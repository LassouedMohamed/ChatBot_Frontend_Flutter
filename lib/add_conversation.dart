import 'package:chat_app/chat.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/conversation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/conversations_model.dart';

class AddConversations extends StatefulWidget {
  const AddConversations({ Key? key }) : super(key: key);

  @override
  State<AddConversations> createState() => _AddConversationsState();
}

class _AddConversationsState extends State<AddConversations> {
  
  String? _token;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) { 
      _token = Provider.of<AuthProvider>(context,listen: false).tokens;
      Provider.of<ConversationProvider>(context,listen: false);
      Provider.of<AuthProvider>(context,listen: false).getAllUsers();
    
    });
    super.initState();
  }

  
  @override
 
  @override
  Widget build(BuildContext context) {
    var provider =Provider.of<AuthProvider>(context,listen: true);
    return Scaffold(
      appBar: AppBar(),
      body: provider.allUsers.isEmpty? Container(): 
      ListView.builder(
        itemCount: provider.allUsers.length,
        itemBuilder: (context,index){
        var conversations= Provider.of<ConversationProvider>(context,listen: false).addConversation(_token, provider.allUsers[index].id);
          return ListTile(
            title: Text("${provider.allUsers[index].name}"),
            subtitle: Text("${provider.allUsers[index].email}"),
            trailing: InkWell(
              onTap: () async{
               var conversations=await Provider.of<ConversationProvider>(context,listen: false).addConversation(_token, provider.allUsers[index].id);

               Navigator.push(context, MaterialPageRoute(builder: (_)=>Chat(conversation: ConversationModel.fromJson(conversations)) ));
              //  Chat(conversation: ConversationModel.fromJson(conversations))
              },
              child: Icon(Icons.add)
              ),
          );
        }
        )
    );
  }
}