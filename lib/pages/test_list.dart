import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class QuestionList extends StatelessWidget {
  const QuestionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String apiUrl = "http://10.0.2.2:8000/api/getQuestion.php";
    List<WordFindQues> listQuestions = [];

    Future<List<dynamic>> fetchQuestion() async {
      Response response = await Dio().get(apiUrl);
      // List jsonRes = json.decode(response.data);
      // print(jsonRes.map((qeus) => new WordFindQues.from))

      return json.decode(response.data);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchQuestion(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  listQuestions.add(WordFindQues(
                    question: snapshot.data[index]['question'].toString(),
                    answer: snapshot.data[index]['answer'].toString(),
                    pathImage: snapshot.data[index]['pathImage'].toString(),
                  ));
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                snapshot.data[index]['pathImage'].toString()),
                          ),
                          title: Text(listQuestions[index].question.toString()),
                          // Text(snapshot.data[index]['question'].toString()),
                          subtitle:
                              Text(snapshot.data[index]['answer'].toString()),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
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
