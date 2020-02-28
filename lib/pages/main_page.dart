import 'package:flutter/material.dart';
import 'package:movie_app/constants/movie_db_provider_const.dart';
import 'package:movie_app/data/provider/movies_notifier.dart';
import 'package:movie_app/repository/movie_db_provider.dart';
import 'package:movie_app/widgets/post_pager.dart';
import 'package:provider/provider.dart';

const double SCALE_FACTOR = 0.9;
const double VIEW_PORT_FACTOR = 0.7;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static int _selectedIndex = 0;
  static PageController _pageController;
  static Page _page = Page();
  static Size size;

  static double nowPlayingTop = 16;
  static double posterTop = 72;
  static double ratingTop = size.width + posterTop + 8;
  static double titleTop = ratingTop + 18 + 8;
  static double genreTop = titleTop + 28 + 8;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<BottomNavigationBarItem> _bnbItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      title: Text('Business'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      title: Text('School'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    movieDBProvider.discoverMovies();
    _pageController = PageController(viewportFraction: VIEW_PORT_FACTOR)
      ..addListener(_onPageViewScrol);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageViewScrol() {
    _page.value = _pageController.page;
  }

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _bnbItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onBottomItemTapped,
      ),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              TextField(),
              Positioned(
                top: nowPlayingTop,
                left: 16,
                height: 40,
                child: FittedBox(
                  child: Text(
                    'Now Playing',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                top: ratingTop,
                left: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blueGrey[800])),
                      child: Text(
                        'IMDB',
                        style: TextStyle(
                            fontSize: 14, color: Colors.blueGrey[800]),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '8.4',
                      style:
                          TextStyle(fontSize: 14, color: Colors.blueGrey[800]),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: titleTop,
                  left: 16,
                  child: Text('John Wick: Chapter3 - Parabellum',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))),
              Positioned(
                  top: genreTop,
                  left: 16,
                  child: Text('Action, Crime, Thriller',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ))),
              Positioned(
                  top: posterTop,
                  left: 0,
                  right: 0,
                  height: size.width,
                  child:
                      Postpager(page: _page, pageController: _pageController)),
            ],
          ),
        ),
      ),
    );
  }
}

class Page extends ChangeNotifier {
  double _page = 0;

  double get value => _page;

  set value(double page) {
    _page = page;
    notifyListeners();
  }
}
