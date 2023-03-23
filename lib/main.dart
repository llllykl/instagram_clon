import 'package:flutter/material.dart';

void main() async {
  runApp(
    const MaterialApp(
      home: App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int a = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            title: const Text(
              'In★gram',
              style: TextStyle(color: Colors.black, fontSize: 26),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.black,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black,
                    size: 30,
                  )),
            ],
          ),
        ),
      ),
      body: const Column(
        children: [
          TopStories(),
          Expanded(flex: 5, child: Content()),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        child: BottomAppBar(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.home_filled,
                    size: 32,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    size: 32,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_box_outlined,
                    size: 32,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.video_collection_outlined,
                    size: 32,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.account_circle_outlined,
                    size: 32,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade300)),
              padding: const EdgeInsets.fromLTRB(14, 10, 0, 10),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/ki.jpg'),
                    radius: 25,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'kimkim',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 190,
                  ),
                  Icon(Icons.more_horiz),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 370,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/ki.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          size: 33,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_bubble_outline_outlined,
                            size: 30)),
                    const SizedBox(
                      width: 216,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon:
                            const Icon(Icons.bookmark_add_outlined, size: 33)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 3, 10, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '좋아요 241,003개',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15.5),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const Row(
                        children: [
                          Text(
                            'kimkim',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('안녕하세요',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Text(
                        '1시간 전',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class TopStories extends StatelessWidget {
  const TopStories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(13, 3, 10, 10),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 38,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
