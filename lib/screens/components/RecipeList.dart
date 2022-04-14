// ignore_for_file: file_names

import 'package:codefood/models/RecipesList.dart';
import 'package:codefood/screens/RecipeDetailPage.dart';
import 'package:codefood/widget.dart';
import 'package:flutter/material.dart';
import 'package:codefood/constant.dart';
import 'package:dio/dio.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key, required this.category}) : super(key: key);
  final int category;
  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late RecipesListModel recipesListModel;
  bool loadRecipe = true;
  late Future getDataRecipeList;

  Future<RecipesListModel?> getRecipesList() async {
    // loadRecipe = true;
    var params = {"categoryId": widget.category};

    try {
      final Response response;
      if (widget.category == 0) {
        response = await Dio().get(
          'https://fe.runner.api.devcode.biofarma.co.id/recipes',
        );
      } else {
        response = await Dio().get(
          'https://fe.runner.api.devcode.biofarma.co.id/recipes',
          queryParameters: params,
        );
      }
      if (response.statusCode == 200) {
        var responseData = response.data;
        recipesListModel = RecipesListModel.fromJson(responseData);
        return recipesListModel;
      }
    } on DioError catch (e) {
      e;
      setState(() {});
    }
    return null;
  }

  Future<RecipesListModel?> sortRecipesList(sort) async {
    Navigator.pop(context);
    setState(() {});
    // loadRecipe = true;
    var params = {"categoryId": widget.category, "sort": sort};
    var params2 = {"sort": sort};
    try {
      final Response response;
      if (widget.category == 0) {
        response = await Dio().get(
            'https://fe.runner.api.devcode.biofarma.co.id/recipes',
            queryParameters: params2);
      } else {
        response = await Dio().get(
            'https://fe.runner.api.devcode.biofarma.co.id/recipes',
            queryParameters: params);
      }

      if (response.statusCode == 200) {
        var responseData = response.data;
        recipesListModel = RecipesListModel.fromJson(responseData);

        return recipesListModel;
      }
    } on DioError catch (e) {
      e;
      setState(() {});
    }
    return null;
  }

  @override
  void initState() {
    getDataRecipeList = getRecipesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // loadRecipe == true
        //     ? Container(
        //         color: Colors.white,
        //         child: const Center(
        //           child: CircularProgressIndicator(
        //             color: red,
        //           ),
        //         ),
        //       )
        //     :
        FutureBuilder(
            future: getDataRecipeList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return recipesListModel.data.total == 0
                    ? Center(
                        child: SizedBox(
                          child: Column(children: [
                            spaceHeight(60.0),
                            SizedBox(
                                height: 200,
                                child:
                                    Image.asset('assets/list-image-empty.png')),
                            spaceHeight(10.0),
                            const Text(
                              "Oops! Resep tidak ditemukan",
                              key: ValueKey('list-text-empty'),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: grey4),
                            )
                          ]),
                        ),
                      )
                    : Stack(children: [
                        Positioned.fill(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: 0.75,
                                crossAxisCount: 2,
                                children: [
                                  ...List.generate(
                                      recipesListModel.data.recipes.length,
                                      (index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecipeDetailPage(
                                                    recipeId: recipesListModel
                                                        .data.recipes[index].id,
                                                    quantity: 1,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        key: ValueKey('list-item-$index'),
                                        margin: const EdgeInsets.all(10),
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
                                            SizedBox(
                                              key: const ValueKey(
                                                  'list-item-image'),
                                              height: 130,
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(
                                                                10)),
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Image.network(
                                                    recipesListModel.data
                                                        .recipes[index].image,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              key: const ValueKey(
                                                  'list-item-text-title'),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Text(
                                                recipesListModel
                                                    .data.recipes[index].name,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                key: const ValueKey(
                                                    'list-item-text-category'),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Text(
                                                  recipesListModel
                                                      .data
                                                      .recipes[index]
                                                      .recipeCategory
                                                      .name,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: grey4),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    key: const ValueKey(
                                                        'list-item-like'),
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: white,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: grey4,
                                                            blurRadius: 1,
                                                            offset: Offset(0.5,
                                                                0.5), // Shadow position
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
                                                          recipesListModel
                                                              .data
                                                              .recipes[index]
                                                              .nReactionLike
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: grey4),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  spaceWidth(6.0),
                                                  Container(
                                                    key: const ValueKey(
                                                        'list-item-neutral'),
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: white,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: grey4,
                                                            blurRadius: 1,
                                                            offset: Offset(0.5,
                                                                0.5), // Shadow position
                                                          ),
                                                        ]),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .sentiment_neutral,
                                                          size: 16,
                                                          color: yellow,
                                                        ),
                                                        spaceWidth(4.0),
                                                        Text(
                                                          recipesListModel
                                                              .data
                                                              .recipes[index]
                                                              .nReactionNeutral
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: grey4),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  spaceWidth(6.0),
                                                  Container(
                                                    key: const ValueKey(
                                                        'list-item-dislike'),
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: white,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: grey4,
                                                            blurRadius: 1,
                                                            offset: Offset(0.5,
                                                                0.5), // Shadow position
                                                          ),
                                                        ]),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .sentiment_very_dissatisfied,
                                                          size: 16,
                                                          color: red,
                                                        ),
                                                        spaceWidth(4.0),
                                                        Text(
                                                          recipesListModel
                                                              .data
                                                              .recipes[index]
                                                              .nReactionDislike
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: grey4),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            spaceHeight(10.0)
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                      offset:
                                          Offset(0.5, 0.5), // Shadow position
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
                        ))
                      ]);
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
            });
  }

  void sortPopUp(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        // isScrollControlled: true,
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
                    getDataRecipeList = sortRecipesList('name_asc');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Urutkan A-Z",
                      key: ValueKey('sort-selection-az'),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    getDataRecipeList = sortRecipesList('name_desc');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Urutkan Z-A",
                      key: ValueKey('sort-selection-za'),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    getDataRecipeList = sortRecipesList('like_desc');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Urutkan Dari Paling Di Sukai",
                      key: ValueKey('sort-selection-favorite'),
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
