import 'dart:convert';

import 'package:blog/post.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class PostService extends ChangeNotifier {
  List<Post> posts = [];
  List<Post> likedPostlist = [];

  PostService() {
    getPosts();
  }

  void toggleLikePost(Post post) async {
    int postId = post.id;

    String? jwtToken = getJwtToken();

    try {
      Response res = await Dio().post(
        'http://192.168.0.4:8080/api/post/$postId/like',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': jwtToken,
          },
        ),
      );

      if (!res.data['liked']) {
        likedPostlist.removeWhere((post) => post.id == postId);
      } else {
        likedPostlist.add(post);
      }
      getPosts();
    } catch (e) {
      print(e);
    }
  }

  void getPosts() async {
    posts.clear();

    Response res = await Dio().get(
      "http://192.168.0.4:8080/api/posts",
    );

    List<dynamic> items = res.data;

    for (Map<String, dynamic> item in items) {
      Post post = Post(
        id: item['id'],
        title: item['title'],
        content: item['content'],
        createdAt: item['createdAt'],
        username: item['username'],
        comments: item['comments'],
        likeCount: item['likeCount'],
      );
      posts.add(post);
    }

    notifyListeners();
  }

  Future<bool> createPost(String title, String content) async {
    final Map<String, dynamic> postData = {
      'title': title,
      'content': content,
    };

    String? jwtToken = getJwtToken();

    try {
      await Dio().post(
        'http://192.168.0.4:8080/api/post',
        data: postData,
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

  Future<bool> update(int postId, String title, String content) async {
    final Map<String, dynamic> postData = {
      'title': title,
      'content': content,
    };

    String? jwtToken = getJwtToken();

    try {
      Response res = await Dio().put(
        'http://192.168.0.4:8080/api/post/$postId',
        data: postData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': jwtToken,
          },
        ),
      );

      if (res.statusCode != 200) {
        return false;
      }

      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(int postId) async {
    String? jwtToken = getJwtToken();

    try {
      Response res = await Dio().delete(
        'http://192.168.0.4:8080/api/post/$postId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': jwtToken,
          },
        ),
      );

      if (res.statusCode != 200) {
        return false;
      }

      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createComment(int postId, String comment) async {
    final Map<String, dynamic> commentData = {
      'comment': comment,
    };

    String? jwtToken = getJwtToken();

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

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateComment(int commentId, String comment) async {
    final Map<String, dynamic> commentData = {
      'comment': comment,
    };

    String? jwtToken = getJwtToken();

    try {
      await Dio().put(
        'http://192.168.0.4:8080/api/comment/$commentId',
        data: commentData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': jwtToken,
          },
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteComment(int commentId) async {
    String? jwtToken = getJwtToken();

    try {
      await Dio().delete(
        'http://192.168.0.4:8080/api/comment/$commentId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': jwtToken,
          },
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  String? getJwtToken() {
    String? jsonString = prefs.getString('Authorization');

    if (jsonString == null) {
      return null;
    }

    String jwtToken = jsonDecode(jsonString);

    return jwtToken;
  }
}
