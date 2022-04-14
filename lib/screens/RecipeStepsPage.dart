// ignore_for_file: file_names

import 'package:codefood/models/RecipeStep.dart';
import 'package:codefood/screens/RatingPage.dart';
import 'package:codefood/widget.dart';
import 'package:flutter/material.dart';
import 'package:codefood/constant.dart';
import 'package:timelines/timelines.dart';
import 'package:dio/dio.dart';

class RecipeStepsPage extends StatefulWidget {
  const RecipeStepsPage(
      {Key? key, required this.recipeId, required this.stepDone})
      : super(key: key);
  final int recipeId, stepDone;
  @override
  State<RecipeStepsPage> createState() => _RecipeStepsPageState();
}

class _RecipeStepsPageState extends State<RecipeStepsPage> {
  late RecipeStepModel recipeStepModel;
  bool loadRecipe = true;
  int stepDone = 0;
  void getRecipeStep() async {
    loadRecipe = true;
    try {
      final response = await Dio().get(
        'https://fe.runner.api.devcode.biofarma.co.id/recipes/${widget.recipeId}/steps',
      );
      if (response.statusCode == 200) {
        var responseData = response.data;
        recipeStepModel = RecipeStepModel.fromJson(responseData);
        stepDone = widget.stepDone;
        loadRecipe = false;
        setState(() {});
      }
    } on DioError catch (e) {
      e;
      loadRecipe = false;
      setState(() {});
    }
  }

  void step() {
    stepDone++;
    setState(() {});
  }

  @override
  void initState() {
    getRecipeStep();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: loadRecipe == true
              ? Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: red,
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(15),
                      child: Column(children: [
                        const Center(
                          child: Text(
                            "Langkah Memasak",
                            key: ValueKey('text-title'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        spaceHeight(30.0),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                FixedTimeline.tileBuilder(
                                  theme: TimelineThemeData(
                                    nodePosition: 0,
                                    indicatorTheme: const IndicatorThemeData(
                                      position: 0,
                                      size: 15.0,
                                    ),
                                    connectorTheme: const ConnectorThemeData(
                                      thickness: 2.5,
                                    ),
                                  ),
                                  builder: TimelineTileBuilder.connected(
                                    connectionDirection:
                                        ConnectionDirection.before,
                                    itemCount: recipeStepModel.data.length,
                                    contentsBuilder: (_, index) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Step ' +
                                                  recipeStepModel
                                                      .data[index].stepOrder
                                                      .toString(),
                                              key: ValueKey('item-step-' +
                                                  index.toString()),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            spaceHeight(10.0),
                                            Text(
                                              recipeStepModel
                                                  .data[index].description,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            spaceHeight(10.0),
                                            // ignore: unrelated_type_equality_checks
                                            index == stepDone
                                                ? SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ElevatedButton(
                                                      key: const ValueKey(
                                                          'button-step-done'),
                                                      style: ButtonStyle(
                                                        padding: MaterialStateProperty
                                                            .all<EdgeInsets>(
                                                                const EdgeInsets
                                                                    .all(10)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    green),
                                                      ),
                                                      onPressed: () async {
                                                        step();
                                                      },
                                                      child: const Text(
                                                          "Mulai Memasak",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: white)),
                                                    ),
                                                  )
                                                : index < stepDone
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.check,
                                                            color: green,
                                                            size: 16.0,
                                                          ),
                                                          spaceWidth(6.0),
                                                          const Text("Selesai",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: green))
                                                        ],
                                                      )
                                                    : Container(),
                                            spaceHeight(15.0),
                                            index !=
                                                    recipeStepModel
                                                            .data.length -
                                                        1
                                                ? const Divider(
                                                    thickness: 1,
                                                  )
                                                : Container(),
                                            spaceHeight(15.0),
                                          ],
                                        ),
                                      );
                                    },
                                    indicatorBuilder: (_, index) {
                                      return index < stepDone
                                          ? const DotIndicator(
                                              color: green,
                                              size: 24,
                                              child: Icon(
                                                Icons.check,
                                                color: white,
                                                size: 16.0,
                                              ),
                                            )
                                          : const OutlinedDotIndicator(
                                              color: grey4,
                                              size: 24,
                                            );
                                    },
                                    connectorBuilder: (_, index, ___) =>
                                        index < stepDone
                                            ? const SolidLineConnector(
                                                thickness: 2,
                                                color: green,
                                              )
                                            : const DashedLineConnector(
                                                thickness: 2,
                                                color: grey4,
                                              ),
                                  ),
                                ),
                                recipeStepModel.data.length == stepDone
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          key: const ValueKey('button-serve'),
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsets>(
                                                const EdgeInsets.all(10)),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(red),
                                          ),
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RatingPage()),
                                            );
                                          },
                                          child: const Text("Sajikan Makanan",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: white)),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
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
                    ))
                  ],
                )),
    );
  }
}
