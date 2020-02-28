import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final double SCALE_FACTOR = 0.7;

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
    _pageController = PageController(viewportFraction: 0.7)
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
              child: Transform(
                transform: Matrix4.diagonal3Values(transScale, transScale, 1)
                ..setTranslationRaw(
                    -1 * size.width * (SCALE_FACTOR - 1).abs(), 0, 0),
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return Consumer<Page>(
                      builder: (context, page, child) {
                        double scale =
                            1 + (SCALE_FACTOR - 1) * (page.value - index).abs();
                        return Container(
                          child: Center(
                            child: Transform.scale(
                                scale: scale,
                                child: Container(
                                  color: Colors.primaries[index],
                                  child: Center(
                                    child: Text(
                                      'page: $index',
                                      style: optionStyle,
                                    ),
                                  ),
                                )),
                          ),
                        );
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

class Page extends ChangeNotifier {
  double _page = 0;

  double get value => _page;

  set value(double page) {
    _page = page;
    notifyListeners();
  }
}
