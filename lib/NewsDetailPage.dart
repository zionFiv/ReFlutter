import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:reflutter/http/JokeRequest.dart';
import 'package:reflutter/http/NewsVo.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter demo",
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
          child: NewsDetail(
            newsId: id,
          ),
        ),
      ),
    );
  }
}

class NewsDetail extends StatefulWidget {
  const NewsDetail({super.key, required this.newsId});

  final String newsId;

  @override
  State<StatefulWidget> createState() {
    return _NewsDetailState();
  }
}

class _NewsDetailState extends State<NewsDetail> {
  NewsDetailVo detailVo = NewsDetailVo(
      title: '',
      images: [],
      content: ' ',
      source: ' ',
      ptime: ' ',
      docid: ' ',
      cover: '');

  @override
  void initState() {
    super.initState();
    _get();
  }

  Future<void> _get() async {
    var vo = await JokeRequest().fetchNewsDetail(widget.newsId);
    setState(() {
      detailVo = vo;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            detailVo.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Image(
            image: NetworkImage(detailVo.cover),
            height: 120.0,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 10.0,
          ),
          Html(data: detailVo.content),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text('${detailVo.source}  ${detailVo.ptime}', style: TextStyle(fontSize: 10.0)), SizedBox(width: 10.0,)],
          ),
        ],
      ),
    );
  }
}
