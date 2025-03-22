import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Utils{
  static const Color mainColor = Color(0xFFFFEE00);
  static const Color mainDarkColor = Color(0xFFDAC81E);
  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();
  static Image menu1 = Image.asset('logo.png');
  static Image bestseller = Image.asset('bestseller');
  static Image bestseller1 = Image.asset('bestseller1');
}

void main(){
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => genzBottomBarSelectionService(),
        )
      ],
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
          navigatorKey: Utils.mainAppNav,
          routes: {
            '/': (context) => SplashScreen(),
            '/main': (context) => genzmain()
          }
      )
    )
  );
}

class SplashScreen extends StatefulWidget{

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  AnimationController? genzController;
  Animation<double>? rotationAnimation;

  @override
  void initState(){
    super.initState();
    genzController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this)..repeat();

    rotationAnimation = Tween<double>(begin: 0, end: 1)
    .animate(CurvedAnimation(parent: genzController!, curve: Curves.linear));
  }

  @override
  void dispose(){
    genzController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 5), (){
      Utils.mainAppNav.currentState!.pushReplacementNamed('/main');
    });

    return Scaffold(
      backgroundColor: Utils.mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RotationTransition(
              turns: rotationAnimation!,
              child: Image.asset('assets/logo.png',width: 350,height: 150),
            ),
            Image.asset('assets/fastfood2.png',width: 350,height: 75)
          ],
        ),
      )
    );
  }
}

class genzmain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: genzSideMenu()
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Utils.mainColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset('assets/fastfood2.png', width: 210)
      ),
      body: Column(
        children: [
          Expanded(
              child: Navigator(
                key: Utils.mainListNav,
                initialRoute: '/main',
                onGenerateRoute: (RouteSettings settings) {

                  Widget page;

                  switch(settings.name){
                    case '/main':
                    page = genzMainPage();
                    break;
                    case '/favorites':
                    page =Center(child: Text('favorites'));
                    break;
                    case '/shoppingcart':
                    page =Center(child: Text('Shopping Cart'));
                    break;
                    default:
                    page = Center(child: Text('main'));
                    break;
                  }

                  return PageRouteBuilder(pageBuilder: (_, __, ___) => page,
                    transitionDuration: const Duration(seconds: 0)
                  );
                },
              )
          ),
          genzBottomBar()
        ]
      )
    );
  }
}

class genzSideMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Utils.mainDarkColor,
      padding: EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
          child: Image.asset('assets/logo.png', width: 100),
          ),
          Image.asset('assets/fastfood2.png', width: 150
          )
        ],
      ),
    );
  }
}

class genzBottomBar extends  StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Consumer<genzBottomBarSelectionService>(
        builder: (context, bottomBarSelectionServise, child){
           return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.trip_origin, color: bottomBarSelectionServise.tabSelection == 'main' ? Utils.mainDarkColor : Utils.mainColor), onPressed: () {
              bottomBarSelectionServise.setTabSelection('main');
          }
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Utils.mainColor), onPressed: () {
            bottomBarSelectionServise.setTabSelection('favorites');
          }
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Utils.mainColor), onPressed: () {
            bottomBarSelectionServise.setTabSelection('shoppingcart');
          }
          ),
        ],
      );
    })
    );
  }
}

class genzBottomBarSelectionService extends ChangeNotifier{
  String? tabSelection = 'main';

  void setTabSelection(String selection) {
    Utils.mainListNav.currentState!.pushReplacementNamed('/' + selection);
    tabSelection = selection;
    notifyListeners();
  }
}

class genzMainPage extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return Column(
      children: [
        genzPager()
      ]
    );
  }
}

class genzPager extends StatefulWidget {
  @override
  State<genzPager> createState() => _genzPagerState();
}

class _genzPagerState extends State<genzPager> {

  List<genzPage> pages = [
    genzPage(imgUrl: Utils.bestseller, LogoimgUrl: Utils.bestseller1),
    genzPage(imgUrl: Utils.bestseller, LogoimgUrl: Utils.bestseller1),
    genzPage(imgUrl: Utils.bestseller, LogoimgUrl: Utils.bestseller1),
  ];

  int currentPage = 0;
  PageController? controller;

  @override
  void initState(){
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child:Column(
        children: [
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              controller: controller,
              children: List.generate(pages.length, (index) {
                genzPage currentPage = pages [index];
                return Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0.0, 5.0)
                      )
                    ],
                    image: DecorationImage(image: NetworkImage(currentPage.imgUrl!),
                      fit: BoxFit.cover
                    )
                  ),
                );
              })
            )
          )
        ],
      ),
    );
  }
}

class genzPage {
  Image? imgUrl;
  Image? LogoimgUrl;

  genzPage ({ this.imgUrl, this.LogoimgUrl});
}
