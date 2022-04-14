// ignore_for_file: file_names

import 'package:codefood/constant.dart';
import 'package:codefood/screens/ThanksPage.dart';
import 'package:codefood/widget.dart';
import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  bool like = false;
  bool neutral = false;
  bool dislike = false;
  void rate(value) async {
    if (value == "like") {
      like = true;
      neutral = false;
      dislike = false;
    } else if (value == "neutral") {
      like = false;
      neutral = true;
      dislike = false;
    } else if (value == "dislike") {
      like = false;
      neutral = false;
      dislike = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Center(
          child: Column(
            children: [
              spaceHeight(40.0),
              const Text(
                "Yaay! Masakanmu sudah siap disajikan",
                key: ValueKey('text-title'),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              spaceHeight(40.0),
              Image.asset(
                'assets/undraw_breakfast_psiw 1.png',
                key: const ValueKey('image-rate'),
              ),
              spaceHeight(40.0),
              const Text(
                "Suka dengan resep dari CodeFood?\nBagaimana rasanya?",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              spaceHeight(40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    key: const ValueKey('button-like'),
                    onTap: () {
                      rate("like");
                    },
                    child: Icon(
                      Icons.mood,
                      size: 100,
                      color: like == true ? green : grey4,
                    ),
                  ),
                  GestureDetector(
                    key: const ValueKey('button-neutral'),
                    onTap: () {
                      rate("neutral");
                    },
                    child: Icon(
                      Icons.sentiment_neutral,
                      size: 100,
                      color: neutral == true ? yellow : grey4,
                    ),
                  ),
                  GestureDetector(
                    key: const ValueKey('button-dislike'),
                    onTap: () {
                      rate("dislike");
                    },
                    child: Icon(
                      Icons.sentiment_very_dissatisfied,
                      size: 100,
                      color: dislike == true ? red : grey4,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    key: const ValueKey('button-rate'),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(10)),
                      backgroundColor:
                          like == true || neutral == true || dislike == true
                              ? MaterialStateProperty.all<Color>(red)
                              : MaterialStateProperty.all<Color>(grey4),
                    ),
                    onPressed: () async {
                      if (like == true || neutral == true || dislike == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ThanksPage()),
                        );
                      }
                    },
                    child: const Text("Berikan Penilaian",
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
