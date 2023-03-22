import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'notification.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => Store1()),
        ChangeNotifierProvider(create: (c) => Store2()),
      ],
      child: MaterialApp(
        theme: style.theme,
        home: const App(),
      ),
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
  var userContent;

  setUserContent(value) {
    setState(() {
      userContent = value;
    });
    print(userContent);
  }

  addMyData() {
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 68,
      'data': 'June 22',
      'content': userContent,
      'liked': false,
      'user': '260',
    };
    setState(() {
      data.insert(0, myData);
    });
  }

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

    initNotification(context);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showNotification2();
          },
          child: const Text('+'),
        ),
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
                    builder: (c) => Upload(
                        userImage: userImage,
                        setUserContent: setUserContent,
                        addMyData: addMyData),
                  ),
                );
              },
              icon: const Icon(Icons.add_box_outlined),
            ),
          ],
        ),
        body: Contents(data: data),
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

class Contents extends StatefulWidget {
  const Contents({super.key, this.data});

  final data;

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
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
              widget.data[i]['image'].runtimeType == String
                  ? Image.network(widget.data[i]['image'])
                  : Image.file(widget.data[i]['image']),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '좋아요 ${widget.data[i]['likes']}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        child: Text((widget.data[i]['user'])),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => const Profile(),
                              transitionsBuilder: (c, a1, a2, child) =>
                                  FadeTransition(opacity: a1, child: child),
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                            ),
                          );
                        },
                      ),
                      Text((widget.data[i]['content'])),
                    ]),
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
  const Upload(
      {super.key, this.userImage, this.setUserContent, this.addMyData});

  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  addMyData();
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.send_sharp,
                  size: 25,
                )),
          ],
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                userImage == null
                    ? const Text('이미지 업로드 실패')
                    : Image.file(userImage),
                TextField(
                  onChanged: (text) {
                    setUserContent(text);
                  },
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                    )),
              ],
            ),
          ],
        ));
  }
}

// state 보관함(store)
class Store1 extends ChangeNotifier {
  var follower = 0;
  bool following = false;
  var profileImage = [];

  getData() async {
    var response = await http
        .get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      profileImage = result;
      print(profileImage);
    } else {
      print('이미지 요청 실패');
    }
    notifyListeners();
  }

  isFollowing() {
    following = !following;

    if (following) {
      follower++;
    } else if (following == false) {
      follower = follower - 1;
    }
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier {
  var name = 'sumin__';
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();

    context.read<Store1>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.watch<Store2>().name),
        ),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: ProfileHeader(),
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Image.network(
                        context.watch<Store1>().profileImage[index]),
                    childCount: context.watch<Store1>().profileImage.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3)),
          ],
        ));
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 29,
            backgroundColor: Colors.grey,
          ),
          Text(
            '팔로워 ${context.watch<Store1>().follower}명',
            style: const TextStyle(fontSize: 16),
          ),
          ElevatedButton(
              onPressed: () {
                context.read<Store1>().isFollowing();
              },
              child: context.watch<Store1>().following == false
                  ? const Text(
                      '팔로우',
                    )
                  : const Text('팔로잉')),
        ],
      ),
    );
  }
}
