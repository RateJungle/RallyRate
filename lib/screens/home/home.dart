import 'package:flutter/material.dart';
import 'package:rally_rate/components/custom_drawer.dart';
import 'package:rally_rate/components/expandable_fab/action_button.dart';
import 'package:rally_rate/components/expandable_fab/expanded_fab.dart';
import 'package:rally_rate/screens/app_navigation/write_screen.dart';

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
          title: Image.asset('assets/logo/app_text.png', scale: 1.8,),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          bottom:  TabBar(
            indicatorColor: Colors.green,
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
              Center(child: Text('Search')),
              Center(child: Text('Following')),
              Center(child: Text('Trending'))
            ]
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
            ),
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.insert_photo),
            ),
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam),
            ),
            ActionButton(
              onPressed: () {
                Navigator.of(context).push(_createPageRoute(const WriteScreen()));
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  Route _createPageRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
