import 'package:codefood/constant.dart';
import 'package:codefood/models/RecipeDetail.dart';
import 'package:codefood/screens/RecipeStepsPage.dart';
import 'package:codefood/screens/LoginPage.dart';
import 'package:codefood/widget.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage(
      {Key? key, required this.recipeId, required this.quantity})
      : super(key: key);
  final int recipeId, quantity;
  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late RecipeDetailModel recipeDetailModel;

  bool loadRecipe = true;
  int _counter = 1;
  var txt = TextEditingController();
  void getRecipeDetail() async {
    loadRecipe = true;
    try {
      final response = await Dio().get(
        'https://fe.runner.api.devcode.biofarma.co.id/recipes/${widget.recipeId}',
      );
      if (response.statusCode == 200) {
        var responseData = response.data;
        recipeDetailModel = RecipeDetailModel.fromJson(responseData);
        _counter = widget.quantity;
        txt.text = _counter.toString();
        loadRecipe = false;
        setState(() {});
      }
    } on DioError catch (e) {
      e;
      loadRecipe = false;
      setState(() {});
    }
  }

  void _incrementCounter(value) {
    if (value == "add") {
      _counter++;
      txt.text = _counter.toString();
      setState(() {});
    } else if (value == "min") {
      _counter--;
      txt.text = _counter.toString();
      setState(() {});
    }
  }

  @override
  void initState() {
    txt.text = _counter.toString();
    getRecipeDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: loadRecipe == true
          ? Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: red,
                ),
              ),
            )
          : SafeArea(
              child: Stack(children: [
                SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Image.network(
                          recipeDetailModel.data.image,
                          key: const ValueKey('detail-image'),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipeDetailModel.data.name,
                              key: const ValueKey('detail-text-title'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            spaceHeight(15.0),
                            SizedBox(
                              child: Row(
                                children: [
                                  Container(
                                    key: const ValueKey('detail-like'),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: grey4,
                                            blurRadius: 1,
                                            offset: Offset(
                                                0.5, 0.5), // Shadow position
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.mood,
                                          size: 16,
                                          color: green,
                                        ),
                                        spaceWidth(4.0),
                                        Text(
                                          recipeDetailModel.data.nReactionLike
                                              .toString()
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: grey4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  spaceWidth(6.0),
                                  Container(
                                    key: const ValueKey('detail-neutral'),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: grey4,
                                            blurRadius: 1,
                                            offset: Offset(
                                                0.5, 0.5), // Shadow position
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.sentiment_neutral,
                                          size: 16,
                                          color: yellow,
                                        ),
                                        spaceWidth(4.0),
                                        Text(
                                          recipeDetailModel
                                              .data.nReactionNeutral
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: grey4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  spaceWidth(6.0),
                                  Container(
                                    key: const ValueKey('detail-dislike'),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: grey4,
                                            blurRadius: 1,
                                            offset: Offset(
                                                0.5, 0.5), // Shadow position
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.sentiment_very_dissatisfied,
                                          size: 16,
                                          color: red,
                                        ),
                                        spaceWidth(4.0),
                                        Text(
                                          recipeDetailModel
                                              .data.nReactionDislike
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: grey4),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Bahan-Bahan",
                              key: ValueKey('detail-text-ingredients'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            spaceHeight(10.0),
                            Container(
                              key: const ValueKey('detail-text-recipe'),
                              child: Column(children: [
                                ...List.generate(
                                    recipeDetailModel.data.ingredientsPerServing
                                        .length, (index) {
                                  return Row(
                                    children: [
                                      Text(
                                        recipeDetailModel
                                                .data
                                                .ingredientsPerServing[index]
                                                .value
                                                .toString() +
                                            " " +
                                            recipeDetailModel
                                                .data
                                                .ingredientsPerServing[index]
                                                .unit
                                                .toString() +
                                            " ",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        recipeDetailModel.data
                                            .ingredientsPerServing[index].item
                                            .toString(),
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  );
                                })
                              ]),
                            )
                          ]),
                    ),
                    Container(
                      key: const ValueKey('form-portion'),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: grey4,
                              blurRadius: 1,
                              offset: Offset(0.5, 0.5), // Shadow position
                            ),
                          ]),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Jumlah Porsi",
                              key: ValueKey('form-text-title-portion'),
                              style: TextStyle(fontSize: 14),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  key: const ValueKey(
                                      'form-button-decrease-portion'),
                                  onTap: () {
                                    if (_counter > 1) {
                                      _incrementCounter("min");
                                    }
                                  },
                                  child: Container(
                                    child: _counter <= 1
                                        ? Image.asset(
                                            'assets/form-button-decrease-portion-disable.png')
                                        : Image.asset(
                                            'assets/form-button-decrease-portion.png'),
                                  ),
                                ),
                                spaceWidth(10.0),
                                SizedBox(
                                  width: 20,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    key: const ValueKey('form-value-portion'),
                                    keyboardType: TextInputType.number,
                                    controller: txt,
                                    decoration: const InputDecoration(
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      border: InputBorder.none,
                                    ),
                                    onFieldSubmitted: (value) {
                                      var val = int.parse(value);
                                      if (val >= 1) {
                                        _counter = val;
                                        txt.text = _counter.toString();
                                        setState(() {});
                                      } else {
                                        _counter = val;
                                        String firstZero = _counter.toString();
                                        if (firstZero == "0") {
                                          txt.text = "1";
                                          final snackBar = SnackBar(
                                            action: SnackBarAction(
                                                label: "OK", onPressed: () {}),
                                            elevation: 6.0,
                                            backgroundColor: black,
                                            behavior: SnackBarBehavior.floating,
                                            content: const Text(
                                              "Jumlah minimal adalah 1",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                          txt.text = txt.text;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          String removeFirstZero = firstZero
                                              .replaceFirst(RegExp(r'^0'), "");
                                          txt.text = removeFirstZero;
                                        }
                                      }
                                    },
                                  ),
                                ),
                                spaceWidth(10.0),
                                GestureDetector(
                                  key: const ValueKey(
                                      'form-button-increase-portion'),
                                  onTap: () {
                                    _incrementCounter("add");
                                  },
                                  child: Image.asset(
                                      'assets/form-button-increase-portion.png'),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            key: const ValueKey('form-button-submit-portion'),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(10)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(red),
                            ),
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String apiToken =
                                  prefs.getString('API_TOKEN') ?? "";
                              if (apiToken.isNotEmpty) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return RecipeStepsPage(
                                      recipeId: recipeDetailModel.data.id,
                                      stepDone: 0,
                                    );
                                  }),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return const LoginPage();
                                  }),
                                );
                              }
                            },
                            child: const Text("Mulai Memasak",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: white)),
                          ),
                        )
                      ]),
                    )
                  ],
                )),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: grey4,
                              blurRadius: 1,
                              offset: Offset(0.5, 0.5), // Shadow position
                            ),
                          ]),
                      child: GestureDetector(
                          key: const ValueKey('button-back'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back))),
                )),
              ]),
            ),
    );
  }
}
