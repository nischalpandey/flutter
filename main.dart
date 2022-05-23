import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:html/dom.dart' as dom;
import 'artical.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Math App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Post(),
    );
  }
}

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future getdata() async {
    final url = Uri.parse(
        "http://www.khullakitab.com/sukunda-pustak-bhawan/solutions/grade-11/mathematics/5/solutions");
    final respone = await http.get(url);

    dom.Document html = dom.Document.html(respone.body);
    final titles = html
        .querySelectorAll(
            '.sidebar-offcanvas.sidebar-nav.no-margin > ul > li > h3 > a')
        .map((element) => element.innerHtml.trim())
        .toList();

    final urls = html
        .querySelectorAll(
            '.sidebar-offcanvas.sidebar-nav.no-margin > ul > li > h3 > a')
        .map(
            (element) => 'https://kullakitab.com/${element.attributes['href']}')
        .toList();

    print("count:${titles.length}");
    setState(() {
      articles = List.generate(titles.length,
          (index) => Article(url: urls[index], title: titles[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Math App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Math App"),
        ),
        body: articles.isEmpty
            ? Center(child: Text("zeroo"))
            :
            //Text("Hello")

            ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  var id = 1;

                  return ListTile(
                    leading: CircleAvatar(child: Text("${id}")),
                    title: Text(
                      article.title,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(article.url),
                  );
                },
              ),
      ),
    );
  }
}
