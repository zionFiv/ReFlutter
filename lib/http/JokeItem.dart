class JokeItem{
  const JokeItem({ required this.content});
  final String content;


  factory JokeItem.fromJson(Map<String, dynamic> json){
    return JokeItem(content: json['content']);
  }


}