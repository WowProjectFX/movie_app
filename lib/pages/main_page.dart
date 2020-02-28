import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final double SCALE_FACTOR = 0.9;
final double VIEW_PORT_FACTOR = 0.7;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  PageController _pageController;
  Page _page = Page();

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
    Size size = MediaQuery.of(context).size;
    double transScale = 2 - SCALE_FACTOR;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _bnbItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onBottomItemTapped,
      ),
      body: Column(
        children: <Widget>[
          TextField(),
          Text('Now Playing'),
          Expanded(
            child: ChangeNotifierProvider.value(
              value: _page,
              child: AspectRatio(
                aspectRatio: 1,
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return Consumer<Page>(
                      builder: (context, page, child) {
                        double scale =
                            1 + (SCALE_FACTOR - 1) * (page.value - index).abs();
                        return Poster(scale: scale);
                      },
                    );
                  },
                  itemCount: 5,
                ),
              ),
            ),
          ),
          Text('IMDB 8.4'),
          Text('John Wick: Chapter3 - Parabellum'),
          Text('Action, Crime, Thriller')
        ],
      ),
    );
  }
}

class Poster extends StatelessWidget {
  const Poster({
    Key key,
    @required this.scale,
    @required this.optionStyle,
  }) : super(key: key);

  final double scale;
  final TextStyle optionStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Transform.scale(
        scale: scale,
        child: Center(
          child: Image.network(
            'https://www.washingtonpost.com/graphics/2019/entertainment/oscar-nominees-movie-poster-design/img/1800/star.jpg'),
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
