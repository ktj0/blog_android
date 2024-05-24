import 'package:blog/comment_service.dart';
import 'package:blog/page/createPost_page.dart';
import 'package:blog/page/detail_page.dart';
import 'package:blog/page/login_page.dart';
import 'package:blog/post.dart';
import 'package:blog/post_service.dart';
import 'package:blog/page/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostService()),
        ChangeNotifierProvider(create: (context) => CommentService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostService>(
      builder: (context, postService, index) {
        List<Post> posts = postService.posts;

        return Scaffold(
          appBar: AppBar(
            title: Text("Blog"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignUpPage(),
                    ),
                  );
                },
                child: Text("회원가입"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginPage(),
                    ),
                  );
                },
                child: Text("로그인"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreatePostPage(),
                    ),
                  );
                },
                child: Text("글쓰기"),
              ),
            ],
          ),
          body: ListView.separated(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              if (postService.posts.isEmpty) return SizedBox();

              Post post = posts.elementAt(index);

              return ListTile(
                title: Text(
                  post.title,
                ),
                subtitle: Text(
                  post.content,
                  maxLines: 3,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(
                        index: index,
                      ),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      post.likeCount.toString(),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        );
      },
    );
  }
}
