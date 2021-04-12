import 'dart:convert';

import 'package:flutter/foundation.dart';

class Response {
  String responserId;
  String responserName;
  int responseCreationTime;
  String response;
  Response({
    @required this.responserId,
    @required this.responseCreationTime,
    @required this.response,
    @required this.responserName,
  });

  Map<String, dynamic> toMap() {
    return {
      'responserId': responserId,
      'responseCreationTime': responseCreationTime,
      'response': response,
      'responserName':responserName,
    };
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(
      responserId: map['responserId'],
      responseCreationTime: map['responseCreationTime'],
      response: map['response'],
      responserName : map['responserName']
    );
  }

  String toJson() => json.encode(toMap());

  factory Response.fromJson(String source) => Response.fromMap(json.decode(source));
}
