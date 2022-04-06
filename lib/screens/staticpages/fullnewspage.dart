import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ketitik/services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utility/colorss.dart';

class FullNewsPage extends StatefulWidget {
  final String fullnewsUrl;
  final String newsId;

  FullNewsPage({Key? key, required this.newsId, required this.fullnewsUrl})
      : super(key: key);

  @override
  _FullNewsPageState createState() => _FullNewsPageState();
}

class _FullNewsPageState extends State<FullNewsPage> {
  bool isLoading = true;
  final _key = UniqueKey();
  APIService apiService = APIService();

  @override
  void initState() {
    apiService.hitReadNewsApi(widget.newsId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("news page screen ${widget.fullnewsUrl}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.themeColor,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'KeTitik',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: widget.fullnewsUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onProgress: (progress) {
              if (progress > 60) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
