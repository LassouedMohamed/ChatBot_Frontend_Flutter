import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
class AuthProvider extends ChangeNotifier {
  AuthService _authService = new AuthService();
  bool _busy = false ;
  String? _token ;
  UserModel? _user;
  List<UserModel> _allUsers =[];

  List<UserModel> get allUsers => _allUsers;
  String? get tokens => _token;
  bool get busy => _busy;
  UserModel? get user =>_user;
  
  setBusy(bool val){
    _busy = val;
    notifyListeners();
  }

  Future getUser()async{
    try{
      setBusy(true);
      bool tokenExist = await getToken();
      if(tokenExist){
        final prefs = await SharedPreferences.getInstance();
        String? prefsToken = prefs.getString('acces_token');
        http.Response response = await _authService.getUser(prefsToken);
        if(response.statusCode == 200){
          try{
            var data = jsonDecode(response.body);
            String token = data['token'];
            _user = UserModel.fromJson(data['user']);
            _token = token;
            saveToken(token);
            return true; 
          }catch(e){
            print("$e");
          }
        }else{
          setBusy(false);
          return false;
        }
      }
      setBusy(false);
      return false; 

    }catch(_){

    }
  }

  Future <bool> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('acces_token');
    if(token != null){
      return true;
    }
    return false;
  }

  Future <void> saveToken(String token)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('acces_token');
    prefs.setString('acces_token', token);
  }

  Future <bool> login(String email, String password) async{
    http.Response response = await _authService.login(email.trim(), password.trim());
    if(response.statusCode ==200){  
      var data = jsonDecode(response.body);
      String token = data['token'];
      _user = UserModel.fromJson(data['user']);
      _token = token;
      saveToken(token);
      return true;
    }
    return false;
  }

  Future <void> logout() async{
    await _authService.logout(_token);
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('acces_token');
    
  }

  Future <void> getAllUsers()async{
    try{
      http.Response response = await _authService.getAllUser(_token);
      
      if(response.statusCode ==200){  
        var data = jsonDecode(response.body);
        _allUsers =[];
        data.forEach((element)=> _allUsers.add(UserModel.fromJson(element)));

      }
    }catch(_){

    }
  }


}