import 'package:blog/post.dart';
import 'package:blog/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final int index;

  const DetailPage({super.key, required this.index});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  bool isEdting = false;
  int postId = 0;
  Map<int, bool> editCommentMode = {};

  @override
  void initState() {
    super.initState();

    final postService = context.read<PostService>();
    Post post = postService.posts[widget.index];

    titleController.text = post.title;
    contentController.text = post.content;
    postId = post.id;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostService>(builder: (context, postService, child) {
      Post post = postService.posts[widget.index];

      return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: titleController,
            readOnly: !isEdting,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                postService.toggleLikePost(post);
              },
              icon: postService.likedPostlist
                      .map((post) => post.id)
                      .contains(post.id)
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(
                      Icons.favorite_border,
                    ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (isEdting) {
                    update(postId);
                  } else {
                    isEdting = true;
                  }
                });
              },
              child: Text(isEdting ? '저장' : '수정'),
            ),
            TextButton(
              onPressed: () {
                delete(postId);
              },
              child: Text('삭제'),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: contentController,
                readOnly: !isEdting,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: '댓글 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    addComment(postId);
                  },
                  child: Text('입력'),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: post.comments.length,
                itemBuilder: (context, index) {
                  if (post.comments.isEmpty) return SizedBox();
                  String comment = post.comments[index]['comment'];
                  bool isEditingComment = editCommentMode[index] ?? false;
                  TextEditingController commentEditController =
                      TextEditingController();

                  return ListTile(
                    title: isEditingComment
                        ? TextField(
                            controller: commentEditController,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          )
                        : Text(
                            comment,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (isEditingComment) {
                              updateComment(post.comments[index]['id'],
                                  commentEditController.text, index);
                            } else {
                              setState(() {
                                editCommentMode[index] = true;
                              });
                            }
                          },
                          icon:
                              Icon(isEditingComment ? Icons.check : Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteComment(post.comments[index]['id']);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void update(int postId) async {
    final String title = titleController.text;
    final String content = contentController.text;

    final postService = context.read<PostService>();

    bool isSuccess = await postService.update(postId, title, content);

    if (isSuccess) {
      setState(() {
        isEdting = false;
      });

      postService.getPosts();
    }
  }

  void delete(int postId) async {
    final postService = context.read<PostService>();

    bool isSuccess = await postService.delete(postId);

    if (isSuccess) {
      postService.getPosts();

      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void addComment(int postId) async {
    final String comment = commentController.text;

    final postService = context.read<PostService>();

    bool isSuccess = await postService.createComment(postId, comment);

    if (isSuccess) {
      commentController.clear();
      postService.getPosts();
    }
  }

  void updateComment(int commentId, String comment, int index) async {
    final postService = context.read<PostService>();

    bool isSuccess = await postService.updateComment(commentId, comment);

    if (isSuccess) {
      editCommentMode[index] = false;
      postService.getPosts();
    }
  }

  void deleteComment(int commentId) async {
    final postService = context.read<PostService>();

    bool isSuccess = await postService.deleteComment(commentId);

    if (isSuccess) {
      postService.getPosts();
    }
  }
}
