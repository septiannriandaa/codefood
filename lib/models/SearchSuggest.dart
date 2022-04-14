// ignore_for_file: file_names

import 'dart:convert';

SearchSuggestModel searchSuggestModelFromJson(String str) =>
    SearchSuggestModel.fromJson(json.decode(str));

String searchSuggestModelToJson(SearchSuggestModel data) =>
    json.encode(data.toJson());

class SearchSuggestModel {
  SearchSuggestModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<SearchSuggest> data;

  factory SearchSuggestModel.fromJson(Map<String, dynamic> json) =>
      SearchSuggestModel(
        success: json["success"],
        message: json["message"],
        data: List<SearchSuggest>.from(
            json["data"].map((x) => SearchSuggest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SearchSuggest {
  SearchSuggest({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory SearchSuggest.fromJson(Map<String, dynamic> json) => SearchSuggest(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
