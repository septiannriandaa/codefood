// ignore_for_file: file_names

import 'package:codefood/models/RecipeCategory.dart';
import 'package:codefood/models/SearchSuggest.dart';
import 'package:codefood/screens/HistoryPage.dart';
import 'package:codefood/screens/LoginPage.dart';
import 'package:codefood/screens/components/RecipeList.dart';
import 'package:codefood/widget.dart';
import 'package:flutter/material.dart';
import 'package:codefood/constant.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  late RecipeCategoryModel recipeCategoryModel;
  late SearchSuggestModel searchSuggestModel;
  late Future getDataRecipeCategory;

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
      return e.response!.data['message'];
    }
    return null;
  }

  void searchRecipe() async {
    try {
      final response = await Dio().get(
        'https://fe.runner.api.devcode.biofarma.co.id/search/recipes?limit&q=na',
      );
      if (response.statusCode == 200) {
        var responseData = response.data;
        searchSuggestModel = SearchSuggestModel.fromJson(responseData);

        setState(() {});
      }
    } on DioError catch (e) {
      e;
    }
  }

  @override
  void initState() {
    getDataRecipeCategory = getRecipeCategory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDataRecipeCategory,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: recipeCategoryModel.data.length + 1,
            child: Scaffold(
              backgroundColor: white,
              appBar: AppBar(
                toolbarHeight: 110,
                backgroundColor: white,
                automaticallyImplyLeading: false,
                title: Row(children: [
                  Expanded(
                    key: const ValueKey('header-input-search'),
                    child: Container(
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
                  ),
                  spaceWidth(10.0),
                  GestureDetector(
                    key: const ValueKey('header-button-history'),
                    onTap: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String apiToken = prefs.getString('API_TOKEN') ?? "";
                      if (apiToken.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return const HistoryPage();
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
                    child: Image.asset(
                      'assets/header-button-history.png',
                    ),
                  )
                ]),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                            isScrollable: true,
                            indicatorColor: red,
                            labelColor: red,
                            indicatorWeight: 4,
                            indicatorSize: TabBarIndicatorSize.label,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              ...List.generate(
                                  recipeCategoryModel.data.length + 1, (index) {
                                return Tab(
                                    child: Text(
                                  index == 0
                                      ? "Semua"
                                      : recipeCategoryModel
                                          .data[index - 1].name,
                                  key: ValueKey("category-button-$index"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ));
                              }),
                            ]),
                      ),
                      spaceHeight(10.0)
                    ],
                  ),
                ),
              ),
              body: TabBarView(children: [
                ...List.generate(recipeCategoryModel.data.length + 1, (index) {
                  return RecipeList(
                    category:
                        index == 0 ? 0 : recipeCategoryModel.data[index - 1].id,
                  );
                }),
              ]),
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
      },
    );
  }
}
