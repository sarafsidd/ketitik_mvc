import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ketitik/services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utility/colorss.dart';

class TermsPrivacyPage extends StatefulWidget {
  final String fullnewsUrl;

  const TermsPrivacyPage({Key? key, required this.fullnewsUrl})
      : super(key: key);

  @override
  _FullNewsPageState createState() => _FullNewsPageState();
}

class _FullNewsPageState extends State<TermsPrivacyPage> {
  bool isLoading = true;
  String pageTitle = "";
  String dataString = "";
  APIService apiService = APIService();

  @override
  void initState() {
    super.initState();
    getUserData();
    if (widget.fullnewsUrl == "terms") {
      pageTitle = "Terms and Services";
    } else {
      pageTitle = "Privacy Policy";
    }
  }

  Future<String> getUserData({pagename}) async {
    String dataStatic = "";
    if (pagename == "terms") {
      dataStatic = (await apiService.getStaticTerms());
    } else {
      dataStatic = (await apiService.getStaticPrivacy());
    }

    print("Data - ${dataString}");
    String withMetaData = ("""<!DOCTYPE html>
<html>
<head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body style='"margin: 0; padding: 0;'>
<div>
$dataStatic
</div>
    </body>
    </html>""");

    String completeHtml = await addFontToHtml(
        withMetaData, "assets/fonts/Montserrat-Regular.ttf", "font/opentype");

    return completeHtml;
  }

  String getFontUri(ByteData data, String mime) {
    final buffer = data.buffer;
    return Uri.dataFromBytes(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
            mimeType: mime)
        .toString();
  }

  Future<String> addFontToHtml(
      String htmlContent, String fontAssetPath, String fontMime) async {
    final fontData = await rootBundle.load(fontAssetPath);
    final fontUri = getFontUri(fontData, fontMime).toString();
    final fontCss =
        '@font-face { font-family: Montserrat; src: url($fontUri); } * { font-family: Montserrat; } * {  font-size: 13pt; }';
    return '<style>$fontCss</style>$htmlContent';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.90,
              margin: EdgeInsets.only(top: 65, left: 10),
              child: FutureBuilder<String>(
                  future: getUserData(pagename: widget.fullnewsUrl),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return WebView(
                        gestureNavigationEnabled: false,
                        initialUrl: new Uri.dataFromString(snapshot.data!,
                                mimeType: 'text/html')
                            .toString(),
                        javascriptMode: JavascriptMode.unrestricted,
                        navigationDelegate: (NavigationRequest request) {
                          return NavigationDecision.prevent;
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
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
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      InkWell(
                        child: Image.asset(
                          "assets/images/left.png",
                          height: 25,
                          width: 25,
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(
                        width: 90,
                      ),
                      Text(
                        pageTitle,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
