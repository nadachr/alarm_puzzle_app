import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class QueryList extends StatefulWidget {
  const QueryList({Key? key}) : super(key: key);

  @override
  _QueryListState createState() => _QueryListState();
}

class _QueryListState extends State<QueryList> {
  final String apiUrl = "http://10.0.2.2:8000/api/getQuestion.php";
  List<WordFindQues> listQuestions = [];

  Future<List<WordFindQues>> getQuestion() async {
    final String apiUrl = "http://10.0.2.2:8000/api/getQuestion.php";
    Response response = await Dio().get(apiUrl);
    List<WordFindQues> lQ = [];
    if (response.statusCode == 200) {
      var body = json.decode(response.data);
      for (var i = 0; i < body!.length - 1; i++) {
        this.listQuestions.add(
              WordFindQues(
                question: body[i]['question'].toString(),
                answer: body[i]['answer'].toString(),
                pathImage: body[i]['pathImage'].toString(),
              ),
            );
      }
    }

    print(listQuestions[0].answer);
    return listQuestions;
  }

  @override
  void initState() {
    // List<WordFindQues> lQ = [];
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    getQuestion();
    // FutureBuilder(
    //   future: getQuestion(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     listQuestions = snapshot.data;
    //   },
    // );
    // listQuestions = getQuestion() as List<WordFindQues>;
    // Dio().get(apiUrl).then((value) {
    //   var body = json.decode(value.data);
    //   for (var i = 0; i < body!.length - 1; i++) {
    //     lQ.add(
    //       WordFindQues(
    //         question: body[i]['question'].toString(),
    //         answer: body[i]['answer'].toString(),
    //         pathImage: body[i]['pathImage'].toString(),
    //       ),
    //     );
    //   }
    //   setState(() {
    //     listQuestions = lQ;
    //   });
    // });

    // Response res = await Dio().get(apiUrl);

    // FutureBuilder<List<WordFindQues>>(
    //   future: fetchQuestion(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     print(snapshot.data);
    //     return snapshot.data;
    //   },
    // );
    // print(listQuestions[0].answer);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<WordFindQues>> fetchQuestion() async {
      Response response = await Dio().get(apiUrl);
      return json.decode(response.data);
    }

    WordFindQues? currentQues;

    getQuestion().then((value) {
      return Scaffold(
        appBar: AppBar(
          title: Text(value[0].answer.toString()),
        ),
        body: Container(),
      );
    });

    return Center(child:Text('here'));
  }
}

class WordFindQues {
  String? question;
  String? pathImage;
  String? answer;
  bool isDone = false;
  bool isFull = false;

  // List<WordFindChar> puzzles = <WordFindChar>[];
  List<String>? arrayBtns = <String>[];

  WordFindQues({
    this.pathImage,
    this.question,
    this.answer,
    this.arrayBtns,
  });

  WordFindQues clone() {
    return new WordFindQues(
      answer: this.answer,
      pathImage: this.pathImage,
      question: this.question,
    );
  }
}
