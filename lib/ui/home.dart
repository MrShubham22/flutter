import 'package:flutter/material.dart';
import 'package:quiz/model/movie.dart';

import '../model/question.dart';

class MovieListView extends StatelessWidget {
  MovieListView({Key? key}) : super(key: key);
  final List<Movie> movieList = Movie.getMovie();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey,
      body: ListView.builder(
          itemCount: movieList.length,
          itemBuilder: (BuildContext, int index) {
            return Stack(children: <Widget>[
              Positioned(child: movieCard(movieList[index], context)),
              Positioned(
                  top: 10, child: movieImage(movieList[index].images[0])),
            ]);
          }),
    );
  }

  Widget movieCard(Movie movie, BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 60),
        width: MediaQuery.of(context).size.width,
        height: 120,
        child: Card(
          color: Colors.black45,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 54),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        "Rating: ${movie.imdbRating} / 10",
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Released: ${movie.released}"),
                      Text(movie.runtime),
                      Text(movie.rated),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: () => {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MovieListviewDetail(movie: movie)))
      },
    );
  }

  Widget movieImage(String imageUrl) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(imageUrl ??
                  'https://play-lh.googleusercontent.com/ZyWNGIfzUyoajtFcD7NhMksHEZh37f-MkHVGr5Yfefa-IX7yj9SMfI82Z7a2wpdKCA=w480-h960-rw'),
              fit: BoxFit.cover)),
    );
  }
}

class MovieListviewDetail extends StatelessWidget {
  final Movie movie;

  const MovieListviewDetail({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.movie.director),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            child: Text("Go Back"),
            onPressed: () {
              debugPrint("navigating back");
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quiz App",
      home: MovieListView(),
    );
  }
}

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int _currentQuestionIndex = 0;
  List<Question> questionBank = [
    Question("Hello World is the most coded program in this world ?", true),
    Question("Is Your name Shubham ?", true),
    Question("Are you from Mumbai ?", false)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Hello World"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey),
      backgroundColor: Colors.blueGrey,
      body: Builder(builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  "images/flag.png",
                  width: 250,
                  height: 280,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.5),
                      border: Border.all(
                          color: Colors.blueGrey.shade400,
                          style: BorderStyle.solid)),
                  height: 120,
                  child: Center(
                      child: Text(
                    questionBank[_currentQuestionIndex].questionText,
                    style: const TextStyle(fontSize: 17, color: Colors.white),
                  )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      _checkAnswer(true, context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade700),
                    child: const Text("True",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _checkAnswer(false, context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade700),
                    child: const Text("False",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _nextQuestion;
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade700),
                      child:
                          const Icon(Icons.arrow_forward, color: Colors.white))
                ],
              ),
              const Spacer(),
            ],
          ),
        );
      }),
    );
  }

  _checkAnswer(bool userChoice, BuildContext context) {
    if (userChoice == questionBank[_currentQuestionIndex].isCorrect) {
      const snackBar = SnackBar(
        content: Text("Correct"),
        duration: Duration(milliseconds: 500),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _nextQuestion();
    } else {
      const snackBar = SnackBar(
        content: Text("Incorrect"),
        duration: Duration(milliseconds: 500),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _nextQuestion();
    }
  }

  _nextQuestion() {
    setState(() {
      _currentQuestionIndex = (_currentQuestionIndex + 1) % questionBank.length;
    });
  }
}
