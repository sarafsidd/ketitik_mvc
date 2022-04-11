// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ketitik/models/newsdata.dart';
import 'package:ketitik/screens/searchscreen/views/search_page.dart';
import 'package:ketitik/services/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';


import '../../../controller/home_controller.dart';
import '../../../utility/colorss.dart';
import '../../../utility/swipeaction.dart';
import '../../profile/profilescreen.dart';
import '../widgets/news_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => HomePageState();
}

class HomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  final APIService _apiService = APIService();
  final HomeController homeController = Get.put(HomeController());
  var articleFull = "";
  var newsId = "";
  var articleCurrent;
  var page_number = 1;
  late Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  bool statusLoggin = false;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  @override
  void initState() {
    homeController.getAllNewsData();
    homeController.getLoggedinStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthscreen = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Container(
                child: Expanded(
          child: Column(
            children: [
              //toolbar
              Visibility(
                  visible: homeController.isVisible.value,
                  child: topBar(widthscreen)),
              Obx(
                () => FutureBuilder<List<DataArticle>?>(
                  future: homeController.getUpdatedList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.79,
                        child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  MyColors.themeColor),
                            )),
                      );
                    } else if (snapshot.data?.length == 0) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.79,
                        child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  MyColors.themeColor),
                            )),
                      );
                    } else {
                      List<DataArticle>? listOfArticle = snapshot.data;
                      var height = homeController.isVisible.value
                          ? MediaQuery.of(context).size.height * 0.77
                          : MediaQuery.of(context).size.height;

                      return GestureDetector(
                          onHorizontalDragEnd: (DragEndDetails details) {
                            if (details.primaryVelocity! > 0) {
                              // User swiped Left
                              Navigator.of(context).push(ProfilePageRoute());
                            } else if (details.primaryVelocity! < 0) {
                              // User swiped Right
                              Navigator.of(context)
                                  .push(FullPageRoute(articleFull, newsId));
                            }
                          },
                          child: CarouselSlider.builder(
                              carouselController: CarouselController(),
                              options: CarouselOptions(
                                scrollDirection: Axis.vertical,
                                height: height,
                                enableInfiniteScroll: false,
                                initialPage: homeController.indexCurrent.value,
                                viewportFraction: 1.0,
                                enlargeCenterPage: true,
                              ),
                              itemCount: listOfArticle?.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                int? lengthCurrent = listOfArticle?.length;

                                print("ListData $lengthCurrent");
                                print("ListIndex $itemIndex");

                                var article = listOfArticle![itemIndex];

                                articleFull = article.url!;
                                newsId = article.id.toString();

                                if (itemIndex == lengthCurrent! - 2) {
                                  homeController.getMoreData(itemIndex);
                                }
                                return fullCourosolView(article);
                              }));
                    }
                  },
                ),
              )
              //main view
            ],
          ),
        ))));
  }

  fullCourosolView(DataArticle article) {
    String image = article.image.toString();
    String author = article.author.toString();
    if (author == null || author.contains("nil")) {
      author = "As per Sources";
    }

    return Stack(
      children: [
        Positioned.fill(
            child: Container(
          color: Colors.white,
        )),
        NewsItem(
            title: article.title,
            imageUrl: image,
            description: article.description ?? "  ",
            author: author,
            source: article.source,
          link: false,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Align(
            alignment: FractionalOffset.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    child: Center(
                      child: Icon(
                        Icons.volunteer_activism,
                        color: MyColors.themeColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    child: Center(
                      child: Icon(
                        Icons.bookmark_border,
                        color: MyColors.themeColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    //final imageFile = await screenshotController.capture();
                    final imageFile = await screenshotController.captureFromWidget(
                        Container(
                          color: Colors.white,
                      child: Column(children: [
                        Text( "https://play.google.com/store/apps/details?id=com.app.ketitik.ketitik"),
                        NewsItem(
                            title: article.title,
                            imageUrl: image,
                            description: article.description ?? "  ",
                            author: author,
                            source: article.source,
                          link: true
                        ),
                      ],),
                    ));
                    if (imageFile != null) {
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final imagePath =
                          await File('${directory.path}/image.png').create();
                      await imagePath.writeAsBytes(imageFile);

                      // String? result = await FlutterSocialContentShare.share(
                      //     type: ShareType.,
                      //     url: "https://www.apple.com",
                      //     quote: "captions");
                      // print(result);

                      /// Share Plugin
                      await Share.shareFiles([imagePath.path],
                          text:
                              "https://play.google.com/store/apps/details?id=com.app.ketitik.ketitik",
                        subject: "https://play.google.com/store/apps/details?id=com.app.ketitik.ketitik"
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    child: Center(
                      child: Icon(
                        Icons.share,
                        color: MyColors.themeColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 55,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(FullPageRoute(articleFull, newsId));
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        image,
                      ),
                      scale: 50,
                      filterQuality: FilterQuality.medium,
                      fit: BoxFit.cover),
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  height: 50,
                  color: MyColors.whiteTransTrans,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: getBottomText(article.title.toString(), 50)),
                ),
              )),
        ),
      ],
    );
  }

  getBottomText(String myText, int length) {
    return Text.rich(TextSpan(
      children: <InlineSpan>[
        TextSpan(
            text: myText.length > length
                ? myText.substring(0, length) + "..."
                : "$myText",
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.normal,
              color: Colors.white,
            )),
        WidgetSpan(
          child: GestureDetector(
            onTap: () {},
            child: Column(
              children: const [
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Read More',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  bottomBarGuest() {
    return GNav(
      gap: 5,
      color: Colors.grey[800],
      activeColor: Colors.black,
      iconSize: 20,
      tabBackgroundColor: Colors.white.withOpacity(1.0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      duration: const Duration(milliseconds: 100),
      tabs: const [
        GButton(
          textStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.normal,
          ),
          icon: Icons.book,
          text: 'All News',
        ),
        GButton(
          icon: Icons.album,
          text: 'Top Stories',
          textStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.normal,
          ),
        ),
        GButton(
          icon: Icons.all_inclusive,
          text: 'Trending',
          textStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
      //selectedIndex: selectedIndex,
      onTabChange: (index) {
        setState(() {
          selectedIndex = index;
          getTabDataGuest(selectedIndex);
        });
      },
    );
  }

  bottomBarLoggedin() {
    return GNav(
      gap: 5,
      color: Colors.grey[800],
      activeColor: Colors.black,
      iconSize: 20,
      tabBackgroundColor: Colors.white.withOpacity(1.0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      duration: const Duration(milliseconds: 100),
      tabs: const [
        GButton(
          textStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.normal,
          ),
          icon: Icons.book,
          text: 'All News',
        ),
        GButton(
          icon: Icons.description,
          text: 'My Feeds',
          textStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.normal,
          ),
        ),
        GButton(
          icon: Icons.album,
          text: 'Top Stories',
          textStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.normal,
          ),
        ),
        GButton(
          icon: Icons.all_inclusive,
          text: 'Trending',
          textStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
      //selectedIndex: selectedIndex,
      onTabChange: (index) {
        setState(() {
          selectedIndex = index;
          getTabData(selectedIndex);
        });
      },
    );
  }

  getTabData(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        homeController.filter.value = "allNews";
        homeController.getAllNewsData();
        break;
      case 1:
        homeController.filter.value = "feeds";
        homeController.getMyFeedData();
        break;
      case 2:
        homeController.filter.value = "top";
        homeController.getTopStoriesData();
        break;
      case 3:
        homeController.filter.value = "trending";
        homeController.getTrendingData();
        break;
      default:
        homeController.filter.value = "allNews";
        homeController.getAllNewsData();
        break;
    }
  }

  getTabDataGuest(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        homeController.filter.value = "allNews";
        homeController.getAllNewsData();
        break;
      case 1:
        homeController.filter.value = "top";
        homeController.getTopStoriesData();
        break;
      case 2:
        homeController.filter.value = "trending";
        homeController.getTrendingData();
        break;
      default:
        homeController.filter.value = "allNews";
        homeController.getAllNewsData();
        break;
    }
  }

  Container topBar(double widthfull) {
    double width = 20;
    double height = 20;
    return Container(
      decoration: BoxDecoration(
        color: MyColors.themeColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        border: Border.all(
          width: 3,
          color: MyColors.themeColor,
          style: BorderStyle.solid,
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const ProfilePage())),
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/menu.png',
                      width: width,
                      height: height,
                      color: Colors.black,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 105.0),
                child: Image.asset(
                  "assets/images/redketitik.png",
                  width: 85,
                  height: 50,
                ),
              ),
              const Spacer(),
              const InkWell(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ImageIcon(
                      AssetImage('assets/images/refresh.png'),
                      size: 20,
                      color: Colors.black,
                    )),
                /*onTap: () => setState(() {
                  selectedIndex = selectedIndex;
                }),*/
              ),
              InkWell(
                  child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: ImageIcon(
                        AssetImage('assets/images/searchbar.png'),
                        size: 27,
                        color: Colors.black,
                      )),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const SearchPage()))),
              const Padding(
                  padding: EdgeInsets.all(5),
                  child: ImageIcon(
                    AssetImage('assets/images/filtericon.png'),
                    size: 22,
                    color: Colors.black,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(() => homeController.isLoggedin.value
              ? bottomBarLoggedin()
              : bottomBarGuest()),
        ],
      ),
    );
  }
}
