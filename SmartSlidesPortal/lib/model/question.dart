import 'dart:convert';

import 'package:flutter/material.dart';

import 'Response.dart';

class Question {
  String questionId;
  String qRaiserId;
  String qRaiserName;
  String question;
  String lectureId;
  int questionRaisingTime;
  List<Response> answers;
  Question({
    @required this.qRaiserId,
    @required this.question,
    @required this.questionRaisingTime,
    @required this.answers,
    @required this.lectureId,
    @required this.questionId,
    @required this.qRaiserName,
  });

  Map<String, dynamic> toMap() {
    return {
      'qRaiserId': qRaiserId,
      'question': question,
      'lectureId': lectureId,
      'questionRaisingTime': questionRaisingTime,
      'answers': answers?.map((x) => x.toMap())?.toList(),
      'questionId': questionId,
      'qRaiserName' : qRaiserName,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        qRaiserId: map['qRaiserId'],
        question: map['question'],
        lectureId: map['lectureId'],
        questionRaisingTime: map['questionRaisingTime'],
        qRaiserName : map['qRaiserName'],
        answers: List<Response>.from(
            map['answers']?.map((x) => Response.fromMap(x))),
        questionId: map['questionId']);
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));
}
