import 'dart:math';

import 'package:alarm_puzzle/utilities/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:word_search/word_search.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GlobalKey<_WordFindWidgetState> globalKey = GlobalKey();

  late List<WordFindQues> listQuestions;

  @override
  void initState() {
    super.initState();
    listQuestions = [
      WordFindQues(
        question: "What is name of this game?",
        answer: "mario",
        pathImage:
            "https://www.imore.com/sites/imore.com/files/styles/xlarge_wm_brw/public/field/image/2021/03/mario-hero.jpg",
      ),
      WordFindQues(
        question: "What is this animal?",
        answer: "cat",
        pathImage:
            "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/domestic-cat-lies-in-a-basket-with-a-knitted-royalty-free-image-1592337336.jpg",
      ),
      WordFindQues(
        question: "What is this animal name?",
        answer: "wolf",
        pathImage:
            "https://earthjustice.org/sites/default/files/styles/story_800x600/public/graywolf_holly_kuchera_shutterstock.jpg?itok=jm6lTbnx",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: MyColors.primary,
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      color: MyColors.primary,
                      child: WordFindWidget(
                        constraints.biggest,
                        listQuestions.map((ques) => ques.clone()).toList(),
                        globalKey,
                        key: globalKey,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordFindWidget extends StatefulWidget {
  Size size;
  List<WordFindQues> listQuestions;
  GlobalKey<_WordFindWidgetState> globalKey;
  WordFindWidget(this.size, this.listQuestions, this.globalKey, {Key? key}) : super(key: key);

  @override
  _WordFindWidgetState createState() => _WordFindWidgetState();
}

class _WordFindWidgetState extends State<WordFindWidget> {
  late Size size;
  late List<WordFindQues> listQuestions;
  int indexQues = 0;
  int hintCount = 0;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    listQuestions = widget.listQuestions;
    generatePuzzle();
  }

  @override
  Widget build(BuildContext context) {
    WordFindQues currentQues = listQuestions[indexQues];

    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => generateHint(),
                  child: Icon(
                    Icons.help,
                    size: 45,
                    color: MyColors.secondary,
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.globalKey.currentState?.generatePuzzle(
                      loop: listQuestions.map((ques) => ques.clone()).toList(),
                    );
                  },
                  child: Icon(
                    Icons.loop,
                    size: 45,
                    color: MyColors.secondary,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => generatePuzzle(left: true),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 45,
                        color: MyColors.secondary,
                      ),
                    ),
                    InkWell(
                      onTap: () => generatePuzzle(next: true),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 45,
                        color: MyColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              // child: Text("Image"),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(maxWidth: size.width / 2 * 1.5),
                child: Image.network(
                  currentQues.pathImage ?? "",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              currentQues.question ?? "Word Question",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: currentQues.puzzles.map((puzzle) {
                    Color color = MyColors.white;

                    if (currentQues.isDone)
                      color = MyColors.success;
                    else if (puzzle.hintShow)
                      color = MyColors.secondary;
                    else if (currentQues.isFull)
                      color = MyColors.danger;
                    else
                      color = MyColors.white;

                    return InkWell(
                      onTap: () {
                        if (puzzle.hintShow || currentQues.isDone) return;

                        currentQues.isFull = false;
                        puzzle.clearValue();
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: constraints.biggest.width / 7 - 6,
                        height: constraints.biggest.width / 7 - 6,
                        margin: EdgeInsets.all(3),
                        child: Text(
                          "${puzzle.currentValue ?? ''}".toUpperCase(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 8,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 16,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool statusBtn = currentQues.puzzles
                        .indexWhere((puzzle) => puzzle.currentIndex == index) >=
                    0;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    Color color = statusBtn ? Colors.white60 : Colors.white;

                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: FlatButton(
                        height: constraints.biggest.height,
                        child: Text(
                          '${currentQues.arrayBtns?[index] ?? ''}'
                              .toUpperCase(),
                          style: TextStyle(
                            color: MyColors.primary,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (!statusBtn) setBtnClick(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  generatePuzzle({
    List<WordFindQues>? loop,
    bool next: false,
    bool left: false,
  }) {
    if (loop != null) {
      indexQues = 0;
      this.listQuestions = <WordFindQues>[];
      this.listQuestions.addAll(loop);
    } else {
      if (next && indexQues < listQuestions.length - 1)
        indexQues++;
      else if (left && indexQues > 0)
        indexQues--;
      else if (indexQues >= listQuestions.length - 1) return;

      setState(() {});

      if (this.listQuestions[indexQues].isDone) return;
    }

    WordFindQues currentQues = listQuestions[indexQues];

    setState(() {});

    final List<String?> wl = [currentQues.answer];

    final WSSettings ws = WSSettings(
      width: 16,
      height: 1,
      orientations: List.from([
        WSOrientation.horizontal,
      ]),
    );

    final WordSearch wordSearch = WordSearch();

    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

    if (newPuzzle.errors.isEmpty) {
      currentQues.arrayBtns = newPuzzle.puzzle.expand((list) => list).toList();
      currentQues.arrayBtns?.shuffle();

      bool isDone = currentQues.isDone;

      if (!isDone) {
        currentQues.puzzles = List.generate(wl[0]!.split("").length, (index) {
          return WordFindChar(
              correctValue: currentQues.answer?.split("")[index]);
        });
      }
    }

    hintCount = 0;
    setState(() {});
  }

  generateHint() async {
    WordFindQues currentQues = listQuestions[indexQues];

    List<WordFindChar> puzzleNoHint = currentQues.puzzles
        .where((puzzle) => !puzzle.hintShow && puzzle.currentIndex == null)
        .toList();

    if (puzzleNoHint.length > 0) {
      hintCount++;
      int indexHint = Random().nextInt(puzzleNoHint.length);
      int countTemp = 0;
      // print(indexHint);

      currentQues.puzzles = currentQues.puzzles.map((puzzle) {
        if (!puzzle.hintShow && puzzle.currentIndex == null) countTemp++;

        if (indexHint == countTemp - 1) {
          puzzle.hintShow = true;
          puzzle.currentValue = puzzle.correctValue;
          puzzle.currentIndex = currentQues.arrayBtns!
              .indexWhere((btn) => btn == puzzle.correctValue);
        }
        return puzzle;
      }).toList();

      if (currentQues.fieldCompleteCorrect()) {
        currentQues.isDone = true;
        setState(() {});

        await Future.delayed(Duration(seconds: 1));
        generatePuzzle(next: true);
      }

      setState(() {});
    }
  }

  Future<void> setBtnClick(int index) async {
    WordFindQues currentQues = listQuestions[indexQues];

    int currentIndexEmpty =
        currentQues.puzzles.indexWhere((puzzle) => puzzle.currentValue == null);

    if (currentIndexEmpty >= 0) {
      currentQues.puzzles[currentIndexEmpty].currentIndex = index;
      currentQues.puzzles[currentIndexEmpty].currentValue =
          currentQues.arrayBtns?[index];

      if (currentQues.fieldCompleteCorrect()) {
        currentQues.isDone = true;
        setState(() {});

        await Future.delayed(Duration(seconds: 1));
        generatePuzzle(next: true);
      }

      setState(() {});
    }
  }
}

class WordFindQues {
  String? question;
  String? pathImage;
  String? answer;
  bool isDone = false;
  bool isFull = false;

  List<WordFindChar> puzzles = <WordFindChar>[];
  List<String>? arrayBtns = <String>[];

  WordFindQues({
    this.pathImage,
    this.question,
    this.answer,
    this.arrayBtns,
  });

  void setWordFindChar(List<WordFindChar> puzzles) => this.puzzles = puzzles;

  void setIsDone() => this.isDone = true;

  bool fieldCompleteCorrect() {
    bool complete =
        this.puzzles.where((puzzle) => puzzle.currentValue == null).length == 0;

    if (!complete) {
      this.isFull = false;
      return complete;
    }

    this.isFull = true;

    String answeredString =
        this.puzzles.map((puzzle) => puzzle.currentValue).join("");

    return answeredString == this.answer;
  }

  WordFindQues clone() {
    return new WordFindQues(
      answer: this.answer,
      pathImage: this.pathImage,
      question: this.question,
    );
  }
}

class WordFindChar {
  String? currentValue;
  int? currentIndex;
  String? correctValue;
  bool hintShow;

  WordFindChar({
    this.correctValue,
    this.currentIndex,
    this.hintShow = false,
  });

  getCurrentValue() {
    if (this.correctValue != null)
      return this.correctValue;
    else if (this.hintShow) return this.correctValue;
  }

  void clearValue() {
    this.currentIndex = null;
    this.currentValue = null;
  }
}
