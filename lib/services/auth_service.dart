
import 'package:http/http.dart' as http;

class AuthService{
  
  Future <http.Response> getUser(token) async{
   

      http.Response response =await http.get(
        Uri.parse('http://10.0.2.2:8000/api/user'),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'}
        ) ;

      return response;
    
  }

  Future <http.Response> getAllUser(token) async{

      http.Response response =await http.get(
        Uri.parse('http://10.0.2.2:8000/api/allUser'),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'}
        ) ;

      return response;
    
  }

  Future <http.Response> login(String email , String password) async{
    
      http.Response response =await http.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        body: {
          'email' : email,
          'password' : password
        });
      return response;

    
  }

  Future<void> logout(String? token) async{
    
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/logout"),
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json'
        },
      );

    
  }

  

}