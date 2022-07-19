// ignore_for_file: file_names

import 'package:codefood/constant.dart';
import 'package:codefood/models/History.dart';
import 'package:codefood/models/RecipeCategory.dart';
import 'package:codefood/screens/RatingPage.dart';
import 'package:codefood/screens/RecipeDetailPage.dart';
import 'package:codefood/screens/RecipeStepsPage.dart';
import 'package:codefood/widget.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late RecipeCategoryModel recipeCategoryModel;
  late HistoryModel historyModel;asdasdasdasd
  late List<HistoryElement> dataHistory;
  late Future getDataRecipeCategory;
  late Future getDataHistory;
  Future<HistoryModel?> getHistory() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String apiToken = _prefs.get('API_TOKEN').toString();

    try {
      Map<String, String> headers = {
        "Authorization": "Bearer $apiToken",
      };
      final response = await Dio().get(
          'https://fe.runner.api.devcode.biofarma.co.id/serve-histories',
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        var responseData = response.data;
        historyModel = HistoryModel.fromJson(responseData);
        // dataHistory
        //     .addAll(historyElementModelFromJson(historyModel.data.history));
        return historyModel;
      }
    } on DioError catch (e) {
      e;
      setState(() {});
    }
    return null;
  }

  Future<HistoryModel?> getFilterHistory(sort, status, param) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String apiToken = _prefs.get('API_TOKEN').toString();
    var body;

    if (sort == true) {
      body = {"categoryId": param};
    } else if (status == true) {
      body = {"status": param};
    }
    try {
      Map<String, String> headers = {
        "Authorization": "Bearer $apiToken",
      };
      final response = await Dio().get(
          'https://fe.runner.api.devcode.biofarma.co.id/serve-histories',
          queryParameters: body,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        var responseData = response.data;
        historyModel = HistoryModel.fromJson(responseData);
        filter = false;
        setState(() {});
        // dataHistory
        //     .addAll(historyElementModelFromJson(historyModel.data.history));
        return historyModel;
      }
    } on DioError catch (e) {
      e;
      setState(() {});
    }
    return null;
  }

  Future<RecipeCategoryModel?> getRecipeCategory() async {
    try {
      final response = await Dio().get(
        'https://fe.runner.api.devcode.biofarma.co.id/recipe-categories',
      );
      if (response.statusCode == 200) {
        var responseData = response.data;
        recipeCategoryModel = RecipeCategoryModel.fromJson(responseData);
        return recipeCategoryModel;
      }
    } on DioError catch (e) {
      e;
      setState(() {});
    }
    return null;
  }

  bool filter = false;
  void showFilter() {
    filter = !filter;
    setState(() {});
  }

  Future<HistoryModel?> sortHistoryList(sort) async {
    Navigator.pop(context);
    setState(() {});
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String apiToken = _prefs.get('API_TOKEN').toString();
    var params = {"sort": sort};
    try {
      Map<String, String> headers = {
        "Authorization": "Bearer $apiToken",
      };
      final response = await Dio().get(
          'https://fe.runner.api.devcode.biofarma.co.id/serve-histories',
          queryParameters: params,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        var responseData = response.data;
        historyModel = HistoryModel.fromJson(responseData);

        // dataHistory
        //     .addAll(historyElementModelFromJson(historyModel.data.history));
        return historyModel;
      }
    } on DioError catch (e) {
      e;
      setState(() {});
    }
    return null;
  }

  @override
  void initState() {
    getDataHistory = getHistory();
    getDataRecipeCategory = getRecipeCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Riwayat",
                    key: ValueKey('text-title'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                spaceHeight(20.0),
                Container(
                  key: const ValueKey('header-input-search'),
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: grey2)),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Image.asset(
                        'assets/akar-icons_search.png',
                        key: const ValueKey('akar-icons:search'),
                      ),
                      hintText: 'Cari Resep',
                      hintStyle: const TextStyle(color: grey4),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                  ),
                ),
                spaceHeight(20.0),
                SizedBox(
                  width: double.infinity,
                  child: Stack(children: [
                    GestureDetector(
                      key: const ValueKey('button-category'),
                      onTap: () {
                        showFilter();
                      },
                      child: const Text(
                        "Tampilkan Semua",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: red),
                      ),
                    ),
                    FutureBuilder(
                        future: getDataHistory,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  ...List.generate(
                                      historyModel.data.history.length,
                                      (index) {
                                    return Container(
                                        key: ValueKey('history-item-$index'),
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: white,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: grey4,
                                                blurRadius: 1,
                                                offset: Offset(0.5,
                                                    0.5), // Shadow position
                                              ),
                                            ]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dateFormatterDefault(historyModel
                                                      .data
                                                      .history[index]
                                                      .createdAt)
                                                  .toString(),
                                              key: const ValueKey(
                                                  'history-item-text-date'),
                                            ),
                                            spaceHeight(10.0),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  key: const ValueKey(
                                                      'history-item-image'),
                                                  width: 100,
                                                  height: 100,
                                                  child: Image.network(
                                                    historyModel
                                                        .data
                                                        .history[index]
                                                        .recipeImage,
                                                    key: const ValueKey(
                                                        'detail-image'),
                                                  ),
                                                ),
                                                spaceWidth(10.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        historyModel
                                                            .data
                                                            .history[index]
                                                            .recipeName,
                                                        key: const ValueKey(
                                                          'history-item-text-title',
                                                        ),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      spaceHeight(5.0),
                                                      Text(
                                                        historyModel.data
                                                            .history[index].id,
                                                        key: const ValueKey(
                                                          'history-item-text-code',
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      spaceHeight(5.0),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            historyModel
                                                                .data
                                                                .history[index]
                                                                .recipeCategoryName,
                                                            key: const ValueKey(
                                                              'history-item-text-category',
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Porsi: " +
                                                                historyModel
                                                                    .data
                                                                    .history[
                                                                        index]
                                                                    .nServing
                                                                    .toString(),
                                                            key: const ValueKey(
                                                              'history-item-text-portion',
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                historyModel.data.history[index]
                                                            .status ==
                                                        "need-reaction"
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const RatingPage()),
                                                          );
                                                        },
                                                        child: const Text(
                                                          "Belum ada penilaian",
                                                          key: ValueKey(
                                                            'history-item-text-rating',
                                                          ),
                                                          style: TextStyle(
                                                              color: grey3),
                                                        ),
                                                      )
                                                    : Row(
                                                        children: [
                                                          historyModel
                                                                      .data
                                                                      .history[
                                                                          index]
                                                                      .reaction ==
                                                                  "like"
                                                              ? const Icon(
                                                                  Icons.mood,
                                                                  size: 22,
                                                                  color: green,
                                                                )
                                                              : historyModel
                                                                          .data
                                                                          .history[
                                                                              index]
                                                                          .reaction ==
                                                                      "neutral"
                                                                  ? const Icon(
                                                                      Icons
                                                                          .sentiment_neutral,
                                                                      size: 22,
                                                                      color:
                                                                          yellow,
                                                                    )
                                                                  : historyModel
                                                                              .data
                                                                              .history[index]
                                                                              .reaction ==
                                                                          "dislike"
                                                                      ? const Icon(
                                                                          Icons
                                                                              .sentiment_very_dissatisfied,
                                                                          size:
                                                                              22,
                                                                          color:
                                                                              red,
                                                                        )
                                                                      : Container(),
                                                          spaceWidth(5.0),
                                                          Text(
                                                            historyModel
                                                                        .data
                                                                        .history[
                                                                            index]
                                                                        .reaction ==
                                                                    "like"
                                                                ? "Yummy"
                                                                : historyModel
                                                                            .data
                                                                            .history[
                                                                                index]
                                                                            .reaction ==
                                                                        "neutral"
                                                                    ? "Lumayan"
                                                                    : historyModel.data.history[index].reaction ==
                                                                            "dislike"
                                                                        ? "Kurang Suka"
                                                                        : "",
                                                            key: const ValueKey(
                                                              'history-item-text-rating',
                                                            ),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: historyModel
                                                                            .data
                                                                            .history[
                                                                                index]
                                                                            .reaction ==
                                                                        "like"
                                                                    ? green
                                                                    : historyModel.data.history[index].reaction ==
                                                                            "neutral"
                                                                        ? yellow
                                                                        : historyModel.data.history[index].reaction ==
                                                                                "dislike"
                                                                            ? red
                                                                            : red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                GestureDetector(
                                                  key: const ValueKey(
                                                    'history-item-button-status',
                                                  ),
                                                  onTap: () async {
                                                    historyModel
                                                                .data
                                                                .history[index]
                                                                .status ==
                                                            "done"
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        RecipeDetailPage(
                                                                          recipeId: historyModel
                                                                              .data
                                                                              .history[index]
                                                                              .recipeId,
                                                                          quantity: historyModel
                                                                              .data
                                                                              .history[index]
                                                                              .nServing,
                                                                        )),
                                                          )
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        RecipeStepsPage(
                                                                          recipeId: historyModel
                                                                              .data
                                                                              .history[index]
                                                                              .recipeId,
                                                                          stepDone: historyModel
                                                                              .data
                                                                              .history[index]
                                                                              .nStepDone,
                                                                        )),
                                                          );
                                                  },
                                                  child: Text(
                                                    historyModel
                                                                .data
                                                                .history[index]
                                                                .status ==
                                                            "done"
                                                        ? "Selesai 100%"
                                                        : "Dalam Proses " +
                                                            (historyModel
                                                                        .data
                                                                        .history[
                                                                            index]
                                                                        .nStepDone /
                                                                    historyModel
                                                                        .data
                                                                        .history[
                                                                            index]
                                                                        .nStep *
                                                                    100)
                                                                .toInt()
                                                                .toString() +
                                                            "%",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: historyModel
                                                                    .data
                                                                    .history[
                                                                        index]
                                                                    .status ==
                                                                "done"
                                                            ? red
                                                            : yellow,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ));
                                  })
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              color: Colors.white,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: red,
                                ),
                              ),
                            );
                          }
                        }),
                    FutureBuilder(
                        future: getDataRecipeCategory,
                        builder: (context, snapshot) {
                          return filter != true
                              ? Container()
                              : Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 25),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: white,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: grey4,
                                          blurRadius: 1,
                                          offset:
                                              Offset(1, 1), // Shadow position
                                        ),
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...List.generate(
                                          recipeCategoryModel.data.length + 2,
                                          (index) {
                                        return index ==
                                                (recipeCategoryModel
                                                            .data.length +
                                                        2) -
                                                    1
                                            ? GestureDetector(
                                                key: ValueKey(
                                                    'category-button-$index'),
                                                onTap: () async {
                                                  getDataHistory =
                                                      getFilterHistory(false,
                                                          true, "progress");
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: const Text(
                                                    "Dalam Proses",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : index ==
                                                    (recipeCategoryModel
                                                                .data.length +
                                                            2) -
                                                        2
                                                ? GestureDetector(
                                                    key: ValueKey(
                                                        'category-button-$index'),
                                                    onTap: () async {
                                                      getDataHistory =
                                                          getFilterHistory(
                                                              false,
                                                              true,
                                                              "done");
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: const Text(
                                                        "Selesai Dimasak",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ))
                                                : GestureDetector(
                                                    key: ValueKey(
                                                        'category-button-$index'),
                                                    onTap: () async {
                                                      getDataHistory =
                                                          getFilterHistory(
                                                              true,
                                                              false,
                                                              recipeCategoryModel
                                                                  .data[index]
                                                                  .id);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Text(
                                                        recipeCategoryModel
                                                            .data[index].name,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                      }),
                                    ],
                                  ),
                                );
                        })
                  ]),
                ),
              ],
            ),
          )),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              key: const ValueKey('button-sort'),
              onTap: () {
                sortPopUp(context);
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: grey4,
                        blurRadius: 1,
                        offset: Offset(0.5, 0.5), // Shadow position
                      ),
                    ]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/urutkan.png'),
                    spaceWidth(10.0),
                    const Text(
                      "Urutkan",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: red),
                    ),
                  ],
                ),
              ),
            ),
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

  void sortPopUp(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            key: const ValueKey('sort-modal-container'),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Urutkan",
                      key: ValueKey('sort-modal-title-text'),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: red),
                    ),
                    GestureDetector(
                      key: const ValueKey('sort-modal-button-close'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 24,
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    getDataHistory = sortHistoryList('newest');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Terbaru",
                      key: ValueKey('sort-selection-newest'),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    getDataHistory = sortHistoryList('oldest');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Terlama",
                      key: ValueKey('sort-selection-oldest'),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    getDataHistory = sortHistoryList('nserve_desc');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Porsi Terbanyak",
                      key: ValueKey('sort-selection-most'),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    getDataHistory = sortHistoryList('nserve_asc');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Porsi Terkecil",
                      key: ValueKey('sort-selection-least'),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
