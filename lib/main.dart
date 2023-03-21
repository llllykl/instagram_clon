import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    MaterialApp(
      theme: style.theme,
      home: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var tab = 0;
  var data = [];
  var userImage;

  getData() async {
    var response = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (response.statusCode == 200) {
      print(response.body);
      var result = jsonDecode(response.body);
      setState(() {
        data = result;
      });
    } else {
      print('데이터 요청 실패');
    }
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 1,
          iconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text('Instagram',
              style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: [
            IconButton(
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);

                if (image != null) {
                  setState(() {
                    userImage = File(image.path);
                  });
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => Upload(userImage: userImage),
                  ),
                );
              },
              icon: const Icon(Icons.add_box_outlined),
            ),
          ],
        ),
        body: ContentWidget(data: data),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
            )
          ]),
          child: BottomNavigationBar(
              iconSize: 25,
              backgroundColor:
                  style.theme.bottomNavigationBarTheme.backgroundColor,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (i) {
                setState(() {
                  tab = i;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined,
                        color: style
                            .theme.bottomNavigationBarTheme.selectedItemColor),
                    label: 'home'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag_outlined), label: 'shop'),
              ]),
        ),
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({super.key, this.data});

  final data;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  var scroll = ScrollController();

  var data1 = {};
  var data2 = {};

  addData() async {
    var response = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var response1 = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more2.json'));
    if (response.statusCode == 200 && response1.statusCode == 200) {
      var result = jsonDecode(response.body);
      var result1 = jsonDecode(response1.body);
      setState(() {
        data1 = result;
        data2 = result1;
        widget.data.add(data1);
        widget.data.add(data2);
      });
    } else {
      print("데이터 추가 요청 실패");
    }
  }

  @override
  void initState() {
    super.initState();

    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        addData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
        controller: scroll,
        itemCount: widget.data.length,
        itemBuilder: (context, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.data[i]['image']),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '좋아요 ${widget.data[i]['likes']}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text((widget.data[i]['user'])),
                        Text((widget.data[i]['content'])),
                      ]),
                ),
              )
            ],
          );
        },
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({super.key, this.userImage});

  final userImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.file(userImage),
          const Text('이미지 업로드 화면'),
          const TextField(),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
        ],
      ),
    );
  }
}
