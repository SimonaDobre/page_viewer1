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

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  void getMovies() {
    get(Uri.parse('https://yts.mx/api/v2/list_movies.json'))
        .then((Response response) {
      // response.body;
      final Map<String, dynamic> list1 =
          jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> list2 = list1['data'] as Map<String, dynamic>;
      final List<dynamic> moviesList = list2['movies'] as List<dynamic>;

      for (final currentMovie in moviesList) {
        titlesList.add(currentMovie['title'] as String);
        images.add(currentMovie['medium_cover_image'] as String);
      }

      moviesList.map((dynamic currentItem) => currentItem['title']);

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
        body: Builder(builder: (context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return PageView.builder(
              itemBuilder: (BuildContext context, int index) {
            final String currentTitle = titlesList[index];
            final String currentImage = images[index];

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
                )
              ],
            );
          });
        }));
  }
}
