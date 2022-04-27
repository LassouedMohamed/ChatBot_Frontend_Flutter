import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/conversation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddConversations extends StatefulWidget {
  const AddConversations({ Key? key }) : super(key: key);

  @override
  State<AddConversations> createState() => _AddConversationsState();
}

class _AddConversationsState extends State<AddConversations> {


  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) { 

    Provider.of<AuthProvider>(context,listen: false).getAllUsers();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<UserModel> listUsers =Provider.of<AuthProvider>(context,listen: true).allUsers;
    return Scaffold(
      appBar: AppBar(),
      body: listUsers.isEmpty? Container(): 
      ListView.builder(
        itemCount: listUsers.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text("${listUsers[index].name}"),
            subtitle: Text("${listUsers[index].email}"),
            trailing: InkWell(
              onTap: () async{
                // Provider.of<ConversationProvider>(context,listen: false);
              },
              child: Icon(Icons.add)
              ),
          );
        }
        )
    );
  }
}