import 'package:flutter/material.dart';
import 'package:rally_rate/components/custom_drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        endDrawer: const CustomDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset('assets/app_title.png', scale: 1.8,),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom:  PreferredSize(
            preferredSize: const Size.fromHeight(50),

            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                indicatorColor: Colors.green,
                isScrollable: true,
                  tabs: [
                    Icon(Icons.search,color: Colors.grey[800],),
                    Text(
                      'Following',
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'Trending',
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    )
                  ]
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  _openEndDrawer();
                },
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar.png',),
                  backgroundColor: Colors.white,
                ),
              ),
            )
          ],
        ),
        body: TabBarView(
            children: [
              Text('Search'),
              Text('Following'),
              Text('Trending')
            ]
        ),
      ),
    );
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }
}
