import 'dart:ffi';

class NewsTypeVo {
  final int typeId;
  final String typeName;

  const NewsTypeVo({required this.typeId, required this.typeName});

  factory NewsTypeVo.fromJson(Map<String, dynamic> json) {
    return NewsTypeVo(typeId: json['typeId'], typeName: json['typeName']);
  }
}

class NewsListVo {
  final String title;
  final List<String> imgList;
  final String source;
  final String newsId;
  final String digest;
  final String postTime;
  final List<String> videoList;

  const NewsListVo(
      {required this.title,
      required this.imgList,
      required this.source,
      required this.newsId,
      required this.digest,
      required this.postTime,
      required this.videoList});

  factory NewsListVo.fromJson(Map<String, dynamic> json) {
    var imgList = json['imgList'];
    List<String> imagesList = [];
    if (imgList != null) {
      imagesList = imgList.cast<String>();
    }
    List<String> videoList = [];
    var vList = json['videoList'];
    if (vList != null) {
      videoList = vList.cast<String>();
    }
    var digestStr = json['digest'];
    if (digestStr == null) digestStr = "";
    var postStr = json['postTime'];
    if (postStr == null) postStr = "";

    return NewsListVo(
        title: json['title'],
        imgList: imagesList,
        source: json['source'],
        newsId: json['newsId'],
        digest: digestStr,
        postTime: postStr,
        videoList: videoList);
  }
}

class NewsDetailVo {
  final String title;
  final List<String> images;
  final String content;
  final String source;
  final String ptime;
  final String docid;
  final String cover;

  const NewsDetailVo(
      {required this.title,
      required this.images,
      required this.content,
      required this.source,
      required this.ptime,
      required this.docid,
      required this.cover});

  factory NewsDetailVo.fromJson(Map<String, dynamic> json) {
    var imgList = json['images'];
    List<String> imagesList = [];
    if (imgList != null) {
      imagesList = imgList.cast<String>();
    }
    return NewsDetailVo(
        title: json['title'],
        images: imagesList,
        content: json['content'],
        source: json['source'],
        ptime: json['ptime'],
        docid: json['docid'],
        cover: json['cover']);
  }
}
