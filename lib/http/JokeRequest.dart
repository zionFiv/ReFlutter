import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reflutter/http/JokeItem.dart';
import 'package:reflutter/http/NewsVo.dart';

import 'BaseVo.dart';

class JokeRequest {
  final String BaseUrl = 'https://www.mxnzp.com/api/';

  JokeRequest._privateConstructor();
  static final JokeRequest _instance = JokeRequest._privateConstructor();
  factory JokeRequest(){
    return _instance;
  }

  Future<List<JokeItem>> fetchJokeList() async {
    var futureVo =  await _fetchBaseData(Uri.parse('${BaseUrl}jokes/list/random'));
    var list = futureVo.data as List;
    List<JokeItem> jokes = list.map((e) => JokeItem.fromJson(e)).toList();
    return jokes;
  }

  Future<List<NewsTypeVo>> fetchNewsType() async {
    List<NewsTypeVo> types = [];
    var futureVo =  await _fetchBaseData(Uri.parse('${BaseUrl}news/types'));
    if(futureVo.data != null) {
      var list = futureVo.data as List;
      types = list.map((e) => NewsTypeVo.fromJson(e)).toList();
    }
    return types;
  }

  Future<NewsDetailVo> fetchNewsDetail(String newsIdStr) async {
    var futureVo ;
    var response =  await http.get(Uri.parse('${BaseUrl}news/details?newsId=$newsIdStr&app_id=gupungkptsnghgly&app_secret=cEZaSDg4bUs3bmNnMktkK2Q5NTFOQT09'));
    if (response.statusCode == 200) {
      futureVo =  BaseVo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fail to load');
    }
    return NewsDetailVo.fromJson(futureVo.data);
  }

  Future<List<NewsListVo>> fetchNewsList(int id, int page) async {
    var futureList ;
    final response = await http.get(Uri.parse('${BaseUrl}news/list?typeId=$id&page=$page&app_id=gupungkptsnghgly&app_secret=cEZaSDg4bUs3bmNnMktkK2Q5NTFOQT09'));
    if (response.statusCode == 200) {
      futureList=  BaseVo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fail to load');
    }
    List<NewsListVo> listVos = [];
    if(futureList.data != null) {
      var list = futureList.data as List;
      print(" $id $page futureList :${list.toString()} ");
      listVos = list.map((e) => NewsListVo.fromJson(e)).toList();
    }
    return listVos;
  }

  Future<BaseVo> _fetchBaseData(Uri url, {Map<String, String>? headers}) async {
    if(headers?.isNotEmpty == true) {
      headers?.addAll({
        'app_id': 'gupungkptsnghgly',
        'app_secret': 'cEZaSDg4bUs3bmNnMktkK2Q5NTFOQT09'
      });
    } else {
      headers = {
        'app_id': 'gupungkptsnghgly',
        'app_secret': 'cEZaSDg4bUs3bmNnMktkK2Q5NTFOQT09'
      };
    }

    final response = await http.get(url, headers: headers);
    print("futureList :${response.body}");
    if (response.statusCode == 200) {
      return BaseVo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fail to load');
    }
  }
}
