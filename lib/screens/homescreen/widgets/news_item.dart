import 'package:flutter/material.dart';

class NewsItem extends StatelessWidget {
  String? title;
  String? imageUrl;
  String? description;
  String? author;
  String? source;

  NewsItem({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.author,
    required this.source,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            title!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: FadeInImage.assetNetwork(
              height: 250,
              image: imageUrl!,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/dummy_news.jpg',
                    fit: BoxFit.fitWidth);
              },
              placeholder: 'assets/images/dummy_news.jpg',
              // your assets image path
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            margin: const EdgeInsets.all(5.0),
            semanticContainer: true,
            elevation: 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      description!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                /* const Spacer(),
                    IconButton(
                      icon: const Icon(MyFlutterApp.bookmark_border,
                          size: 22, color: Colors.black),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(MyFlutterApp.share,
                          size: 22, color: Colors.black),
                      onPressed: () {},
                    ),*/
                author == "---"
                    ? Text("")
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text("Author : ${author!}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.clip),
                            ),
                          ),
                        ],
                      ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text("Source : ${source!}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.clip),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
