// ignore_for_file: file_names

import 'package:codefood/screens/RecipeListPage.dart';
import 'package:flutter/material.dart';
import 'package:codefood/constant.dart';
import 'package:codefood/widget.dart';

class ThanksPage extends StatefulWidget {
  const ThanksPage({Key? key}) : super(key: key);

  @override
  State<ThanksPage> createState() => _ThanksPageState();
}

class _ThanksPageState extends State<ThanksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Center(
          child: Column(
            children: [
              spaceHeight(80.0),
              Image.asset(
                'assets/image-thanks.png',
                key: const ValueKey('image-thanks'),
              ),
              spaceHeight(40.0),
              const Text(
                "Terimakasih telah memberikan penilaianmu!",
                key: ValueKey('text-description'),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              spaceHeight(40.0),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    key: const ValueKey('button-home'),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(10)),
                        backgroundColor: MaterialStateProperty.all<Color>(red)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecipeListPage()),
                      );
                    },
                    child: const Text("Kembali ke Beranda",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: white)),
                  ),
                ),
              ))
            ],
          ),
        ),
      )),
    );
  }
}
