import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  final List<String> titlesList = <String>[];
  final List<String> images = <String>[];

  final List<List<String>> genre = <List<String>>[];
  final List<double>? rating = <double>[];

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  void getMovies() {
    get(Uri.parse('https://yts.mx/api/v2/list_movies.json'))
        .then((Response response) {
      final Map<String, dynamic> list1 =
          jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> list2 = list1['data'] as Map<String, dynamic>;
      final List<Map<dynamic, dynamic>> moviesList =
          List<Map<dynamic, dynamic>>.from(list2['movies'] as List<dynamic>);

      for (int i = 0; i < moviesList.length; i++) {
        final Map<dynamic, dynamic> currentMovie = moviesList[i];

        titlesList.add(currentMovie['title'] as String);
        images.add(currentMovie['medium_cover_image'] as String);
        genre.add(currentMovie['genres'] as List<String>);
        rating?.add(currentMovie['rating'] as double);
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return PageView.builder(
            itemBuilder: (BuildContext context, int index) {
              final String currentTitle = titlesList[index];
              final String currentImage = images[index];
              final List<String> currentGenreList = genre[index];
              final double? currentRating = rating?[index];

              return Column(
                children: <Widget>[
                  Image.network(currentImage),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Text(
                      currentTitle,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(currentGenreList[0]),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(38),
                        child: Text(
                          '$currentRating',
                          style: TextStyle(fontSize: 40),
                        ),
                      ), //$currentRating
                      const Padding(
                        padding: EdgeInsets.all(38),
                        child: Text(
                          '2',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(38),
                        child: Text(
                          '3',
                          style: TextStyle(fontSize: 40),
                        ),
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Buy Tickets'))
                ],
              );
            },
          );
        },
      ),
    );
  }
}
