import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  void signup(String id, String password, String email, bool isAdmin,
      String? adminToken) async {
    final Map<String, dynamic> signupData = {
      'username': id,
      'password': password,
      'email': email,
      'admin': isAdmin,
      'adminToken': isAdmin ? adminToken : null,
    };

    try {
      Response res = await Dio().post(
        'http://192.168.0.4:8080/api/user/signup',
        data: signupData,
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Content-Type 헤더 설정
          },
        ),
      );

      if (res.statusCode == 200) {
        print('성공');
      } else {
        print('실패');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> login(String id, String password) async {
    final Map<String, dynamic> loginData = {
      'username': id,
      'password': password,
    };

    try {
      Response res = await Dio().post(
        'http://192.168.0.4:8080/api/user/login',
        data: loginData,
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Content-Type 헤더 설정
          },
        ),
      );

      if (res.statusCode == 200) {
        String? jwtToken = res.headers.value('authorization');
        if (jwtToken != null) {
          String jsonString = jsonEncode(jwtToken);

          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString('Authorization', jsonString);

          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
