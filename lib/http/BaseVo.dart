

class BaseVo {
  final String msg;
  final int code;
  final dynamic data;

  const BaseVo({
    required this.msg,
    required this.code,
    required this.data
  });

  factory BaseVo.fromJson(Map<String, dynamic> json) {
    return BaseVo(msg: json['msg'], code: json['code'], data: json['data'] );
  }
}