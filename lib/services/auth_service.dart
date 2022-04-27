
import 'package:http/http.dart' as http;

class AuthService{
  
  Future  getUser(token) async{
    try{

      http.Response response =await http.get(
        Uri.parse('http://10.0.2.2:8000/api/user'),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'}
        ) ;

      return response;
    }catch(_){
      
    }
  }

  Future getAllUser(token) async{
    try{

      http.Response response =await http.get(
        Uri.parse('http://10.0.2.2:8000/api/allUser'),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'}
        ) ;

      return response;
    }catch(_){
      
    }
  }

  Future login(String email , String password) async{
    try{
      http.Response response =await http.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        body: {
          'email' : email,
          'password' : password
        });
      return response;

    }catch(_){

    }
  }

  Future<void> logout(String? token) async{
    try{
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/logout"),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'
        },
      );

    }catch(_){

    }
  }

  

}