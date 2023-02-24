import 'package:flutter/material.dart';
import 'package:reflutter/http/JokeRequest.dart';

import 'http/JokeItem.dart';


class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  State<JokePage> createState() {
    return _JokePageState();
  }

}

class _JokePageState extends State<JokePage> {
  final _scrollController = ScrollController();
  List<JokeItem> items = [JokeItem(content: 'content')];

  @override
  void initState() {
    super.initState();
    print('initState object');
    _get();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  Future<void> _get() async {
    var jokes = await JokeRequest().fetchJokeList();
    setState(() {
      items.clear();
      items.addAll(jokes);
    });
  }

  Future<void> _getMore() async {
    var jokes = await JokeRequest().fetchJokeList();
    setState(() {
      items.addAll(jokes);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(0, 30, 0, 2),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: items.map((item) {
          return JokeListItem(item: item);
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

}

class JokeListItem extends StatelessWidget {
  JokeListItem({required this.item}) : super(key: ObjectKey(item));
  final JokeItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white
      ),
      child: Text(item.content),
    );
  }
}