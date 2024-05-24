import 'dart:convert';

import 'package:blog/comment.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class CommentService extends ChangeNotifier {
  List<Comment> comments = [];

  Future<bool> create(int postId, String comment) async {
    final Map<String, dynamic> commentData = {
      'comment': comment,
    };

    String? jsonString = prefs.getString('Authorization');

    if (jsonString == null) {
      return false;
    }

    String jwtToken = jsonDecode(jsonString);

    try {
      await Dio().post(
        'http://192.168.0.4:8080/api/$postId/comment',
        data: commentData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': jwtToken,
          },
        ),
      );

      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  void updateComment(int commentId, String comment, int index) async {}
}
