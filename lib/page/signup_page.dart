import 'package:blog/user_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adminTokenController = TextEditingController();
  bool isAdmin = false;
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: isAdmin,
                    onChanged: (value) {
                      setState(() {
                        isAdmin = value!;
                      });
                    },
                  ),
                  Text("관리자 계정으로 만들기"),
                ],
              ),
              if (isAdmin)
                Column(
                  children: [
                    SizedBox(height: 16),
                    TextField(
                      controller: adminTokenController,
                      decoration: InputDecoration(
                        labelText: 'Admin Token',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  submit();
                },
                child: Text("회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    final dynamic id = idController.text;
    final dynamic password = passwordController.text;
    final dynamic email = emailController.text;
    final dynamic _isAdmin = isAdmin;
    final dynamic adminToken = adminTokenController.text;

    userService.signup(id, password, email, _isAdmin, adminToken);
  }
}
