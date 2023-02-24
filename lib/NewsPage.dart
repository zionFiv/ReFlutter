import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflutter/MyAppState.dart';
import 'package:reflutter/NewsDetailPage.dart';
import 'package:reflutter/http/JokeItem.dart';
import 'package:reflutter/http/JokeRequest.dart';
import 'package:reflutter/http/NewsVo.dart';
import 'package:reflutter/joke.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewsPageState();
  }
}

class _NewsPageState extends State<NewsPage> {
  List<NewsTypeVo> types = [];
  int id = 0;
  late MyAppState appState;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = Provider.of<MyAppState>(context);
  }

  Future<void> _getData() async {
    var list = await JokeRequest().fetchNewsType();

    if (list.isNotEmpty) {
      setState(() {
        types.addAll(list);
        // appState.setTypeId(types.first.typeId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 25.0,),
        SizedBox(
          height: 45.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: types.map((e) {
              return NewsTypeTxt(item: e);
            }).toList(),
          ),
        ),
        Expanded(
          child: NewsList(),
        )
      ],
    );
  }
}

class NewsTypeTxt extends StatelessWidget {
  NewsTypeTxt({required this.item}) : super(key: ObjectKey(item));
  final NewsTypeVo item;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    MaterialColor color;
    if (appState.typeId == item.typeId) {
      color = Colors.red;
    } else {
      color = Colors.blue;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              appState.setTypeId(item.typeId);
            },
            child: Container(
              width: 60.0,
              constraints: const BoxConstraints(minHeight: 45.0),
              alignment: Alignment.center,
              child: Text(
                textAlign: TextAlign.center,
                item.typeName,
                style: TextStyle(fontSize: 14.0, color: color),
              ),
            ))
      ],
    );
  }
}

class NewsList extends StatefulWidget {
  NewsList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewsListState();
  }
}

class _NewsListState extends State<NewsList> {
  int page = 1;
  int id = 0;
  late List newsList = [];
  final _scrollController = ScrollController();
  var appState;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("futureList didChangeDependencies");
    //特别重要的两行
    appState = Provider.of<MyAppState>(context);
    _onRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _onRefresh() async {
    var news = await JokeRequest().fetchNewsList(appState.typeId, 1);
    setState(() {
      page = 1;
      newsList.clear();
      newsList.addAll(news);
    });
  }

  Future<void> _getMore() async {
    var news = await JokeRequest().fetchNewsList(appState.typeId, page + 1);
    setState(() {
      page++;
      newsList.addAll(news);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        controller: _scrollController,
        children: newsList.map((e) => NewsListItem(vo: e)).toList(),
      ),
    );
  }
}

class NewsListItem extends StatelessWidget {
  NewsListItem({required this.vo}) : super(key: ObjectKey(vo));
  final NewsListVo vo;

  @override
  Widget build(BuildContext context) {
    String img = "";
    ImageProvider imgProvider;
    if (vo.imgList.isNotEmpty) {
      img = vo.imgList.first;
      imgProvider = NetworkImage(img);
    } else {
      imgProvider = const AssetImage('assets/groupon_bar_bg.png');
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return NewsDetailPage(id: vo.newsId);
          }),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vo.title,
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: imgProvider,
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    vo.digest,
                    style: TextStyle(fontSize: 12.0),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
