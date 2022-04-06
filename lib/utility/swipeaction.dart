import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../screens/profile/profilescreen.dart';
import '../screens/staticpages/fullnewspage.dart';
import '../screens/staticpages/privacyandterms.dart';

class ProfilePageRoute extends CupertinoPageRoute {
  ProfilePageRoute()
      : super(builder: (BuildContext context) => const ProfilePage());
}

finishPage(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    SystemNavigator.pop();
  }
}

class FullPageRoute extends CupertinoPageRoute {
  FullPageRoute(String buildUrl, String newsId)
      : super(
            builder: (BuildContext context) => FullNewsPage(
                  newsId: newsId,
                  fullnewsUrl: buildUrl,
                ));
}

class TermsPrivacyRoute extends CupertinoPageRoute {
  TermsPrivacyRoute(String buildUrl)
      : super(
            builder: (BuildContext context) => TermsPrivacyPage(
                  fullnewsUrl: buildUrl,
                ));
}
