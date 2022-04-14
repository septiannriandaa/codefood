// ignore_for_file: file_names

import 'package:codefood/constant.dart';
import 'package:codefood/screens/RecipeListPage.dart';
import 'package:codefood/widget.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  bool checkEmail = true;
  bool checkPassword = true;
  int countError = 0;

  void login(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(red),
            ),
          ),
        );
      },
    );
    var body = {
      "username": usernameController.text,
      "password": passwordController.text
    };

    try {
      var response = await Dio().post(
          'https://fe.runner.api.devcode.biofarma.co.id/auth/login',
          data: body);
      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            "API_TOKEN", response.data['data']['token'].toString());
        usernameController.clear();
        passwordController.clear();
        checkEmail = true;
        checkPassword = true;
        setState(() {});
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecipeListPage()),
        );
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        SnackBar(
          key: const ValueKey('form-alert-container'),
          action: SnackBarAction(
              key: const ValueKey('form-alert-button-ok'),
              label: "OK",
              onPressed: () {}),
          elevation: 6.0,
          backgroundColor: black,
          behavior: SnackBarBehavior.floating,
          content: Text(
            e.response!.data['message'],
            key: const ValueKey('form-alert-button-text'),
            style: const TextStyle(color: Colors.white),
          ),
        );
        Navigator.pop(context);
      } else if (e.response!.statusCode == 401) {
        final snackBar = SnackBar(
          key: const ValueKey('form-alert-container'),
          action: SnackBarAction(
              key: const ValueKey('form-alert-button-ok'),
              label: "OK",
              onPressed: () {}),
          elevation: 6.0,
          backgroundColor: black,
          behavior: SnackBarBehavior.floating,
          content: const Text(
            "Email atau Password anda salah",
            key: ValueKey('form-alert-button-text'),
            style: TextStyle(color: Colors.white),
          ),
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          countError++;
        });
      } else if (e.response!.statusCode == 403) {
        if (countError < 4) {
          final snackBar = SnackBar(
            key: const ValueKey('form-alert-container'),
            action: SnackBarAction(
                key: const ValueKey('form-alert-button-ok'),
                label: "OK",
                onPressed: () {}),
            elevation: 6.0,
            backgroundColor: black,
            behavior: SnackBarBehavior.floating,
            content: const Text(
              "Terlalu banyak percobaan, pastikan data Email dan Password anda benar",
              key: ValueKey('form-alert-button-text'),
              style: TextStyle(color: Colors.white),
            ),
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          final snackBar = SnackBar(
            key: const ValueKey('form-alert-container'),
            action: SnackBarAction(
                key: const ValueKey('form-alert-button-ok'),
                label: "OK",
                onPressed: () {}),
            elevation: 6.0,
            backgroundColor: black,
            behavior: SnackBarBehavior.floating,
            content: const Text(
              "Terlalu banyak percobaan, coba kembali setelah 1 menit",
              key: ValueKey('form-alert-button-text'),
              style: TextStyle(color: Colors.white),
            ),
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Future.delayed(const Duration(minutes: 1), () {
            setState(() {
              countError = 0;
            });
          });
        }
      } else {
        Navigator.pop(context);
        e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: SizedBox(
              child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                    color: red,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0))),
                child: Image.asset(
                  'assets/content-logo.png',
                  key: const ValueKey('content-logo'),
                ),
              ),
              spaceHeight(40.0),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      key: ValueKey('form-text-email'),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    spaceHeight(10.0),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: grey)),
                      child: TextFormField(
                        key: const ValueKey('form-input-email'),
                        keyboardType: TextInputType.emailAddress,
                        controller: usernameController,
                        decoration: const InputDecoration(
                            hintText: 'Masukan Email',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontStyle: FontStyle.italic, color: grey4),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10)),
                        onSaved: (newValue) =>
                            usernameController.text = newValue!,
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              checkEmail = false;
                            } else {
                              checkEmail = true;
                            }
                          });
                        },
                        // onFieldSubmitted: (value) {
                        //   if (!value.contains("@")) {
                        //     final snackBar = SnackBar(
                        //       key: const ValueKey('form-alert-container'),
                        //       action: SnackBarAction(
                        //           key: const ValueKey('form-alert-button-ok'),
                        //           label: "OK",
                        //           onPressed: () {}),
                        //       elevation: 6.0,
                        //       backgroundColor: black,
                        //       behavior: SnackBarBehavior.floating,
                        //       content: const Text(
                        //         "Format Email tidak sesuai",
                        //         key: ValueKey('form-alert-button-text'),
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //     );
                        //     ScaffoldMessenger.of(context)
                        //         .showSnackBar(snackBar);
                        //   }
                        // },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email harus diisi';
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Format Email tidak sesuai';
                          }
                          return null;
                        },
                      ),
                    ),
                    spaceHeight(20.0),
                    const Text(
                      "Password",
                      key: ValueKey('form-text-password'),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    spaceHeight(10.0),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: grey)),
                      child: TextFormField(
                          key: const ValueKey('form-input-password'),
                          obscureText: true,
                          controller: passwordController,
                          decoration: const InputDecoration(
                              hintText: 'Masukan Password',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic, color: grey4),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10)),
                          onSaved: (newValue) =>
                              passwordController.text = newValue!,
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                checkPassword = false;
                              } else {
                                checkPassword = true;
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password harus diisi';
                            }
                            if (value.length < 6) {
                              return 'Password Minimal 6 Karakter';
                            }
                            return null;
                          }),
                    ),
                  ],
                ),
              ),
              spaceHeight(40.0),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  key: const ValueKey('form-button-login'),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(10)),
                    backgroundColor: checkEmail == true || checkPassword == true
                        ? MaterialStateProperty.all<Color>(grey4)
                        : MaterialStateProperty.all<Color>(red),
                  ),
                  onPressed: () {
                    if (checkEmail == false || checkPassword == false) {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        login(context);
                      }
                    }
                  },
                  child: const Text("Login",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: white)),
                ),
              ),
              spaceHeight(70.0),
              GestureDetector(
                key: const ValueKey('form-button-skip'),
                onTap: (() async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString("API_TOKEN", "");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RecipeListPage()),
                  );
                }),
                child: const Text(
                  "Lewati Login",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: red),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
