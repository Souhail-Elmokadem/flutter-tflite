



import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:testtp1android/cubit/auth_state.dart';
import 'package:http/http.dart' as http;
import 'package:testtp1android/env/env.dart';
import 'package:http/src/response.dart';
import 'package:testtp1android/shared/shared_preferences/sharedNatwork.dart';
import 'package:testtp1android/shared/shared_preferences/shared_token.dart';
class AuthCubit extends Cubit<AuthState>{
    AuthCubit():super(Initializer());






    // Sign-in method
    Future<void> signIn(String email, String password) async {
      emit(LoginLoading());
      print("-------1-------------------");
      dynamic messageError = "";

      try {
        //pour tester transition
        //await Future.delayed(Duration(seconds: 2));

        Response r = await http.post(Uri.parse("http://192.168.11.105:8087/signin")  ,
          headers: {
        'Content-Type':'application/json'
        },
          body:jsonEncode({
            "email": email,
            "password": password,
          }),);
        print("-------2-------------------");

        dynamic data = jsonDecode(r.body);
        print(data);
        messageError = data['message'];


        String accessToken = data['access-token'];
        TokenManager.clearTokens();
        TokenManager.saveAccessToken(accessToken);

        print(accessToken);
        print("----------------------------");
        
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailed(messageError));
      }
    }
    Future<void> signUp(String name,String email, String password) async {
      emit(LoginLoading());
      print("-------1-------------------");
      dynamic messageError = "";
      try {
        //pour tester transition
        //await Future.delayed(Duration(seconds: 2));

        Response r = await http.post(Uri.parse("http://192.168.11.105:8087/signup")  ,
          headers: {
        'Content-Type':'application/json'
        },
          body:jsonEncode({
            "name":name,
            "email": email,
            "password": password,
          }),);
        print("-------2-------------------");

        dynamic data = jsonDecode(r.body);
        print(data);
        messageError = data['message'];


        String accessToken = data['access-token'];
        TokenManager.clearTokens();
        TokenManager.saveAccessToken(accessToken);

        print(accessToken);
        print("----------------------------");

        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailed(messageError));
      }
    }
    Future<Map<String, dynamic>?> userInfo() async {
      try {
        String? accessToken = await TokenManager.getAccessToken();
        if (accessToken == null) {
          return null;
        }

        final response = await http.get(
          Uri.parse("http://192.168.11.105:8087/api/person/userinfo"),
          headers: {
            'Authorization': "Bearer $accessToken",
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    }


}