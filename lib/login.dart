import 'package:chat_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    
     WidgetsBinding.instance!.addPostFrameCallback((_) async{
      bool nav = await Provider.of<AuthProvider>(context , listen: false).getUser();
      if(nav){
        Navigator.of(context).pushReplacementNamed('/conversation');
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context ,listen: true);
    return Scaffold(
      body: provider.busy? CircularProgressIndicator() : Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _email,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
              decoration: InputDecoration(label: Text("email")),
            ),
            TextFormField(
              controller: _password,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              decoration: InputDecoration(label: Text("password")),
            ),
            Provider.of<AuthProvider>(context , listen: true).busy ? CircularProgressIndicator():
            ElevatedButton(
              onPressed: ()async{
                if(_formKey.currentState!.validate()){
                  bool auth = await provider.login(_email.text, _password.text);
                  if(auth) Navigator.of(context).pushReplacementNamed('/conversation');
                  else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("user incorrect"),));

                }
              }, 
              child: Text('connecter')
            ),
          ]),
      ),
    );
  }
}