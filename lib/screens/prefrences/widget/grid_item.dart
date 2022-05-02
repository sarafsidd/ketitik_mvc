import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ketitik/utility/PreferenceModel.dart';
import 'package:ketitik/utility/colorss.dart';

class GridItem extends StatefulWidget {
  final Key key;
  final PreferenceModelSve item;
  final ValueChanged<bool> isSelected;
  bool isSelectedVal = false;

  GridItem(
      {required this.item,
      required this.isSelectedVal,
      required this.isSelected,
      required this.key});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelectedVal;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            isSelected = false;
          } else {
            isSelected = true;
          }
          widget.isSelectedVal = isSelected;
          widget.isSelected(widget.isSelectedVal);
        });
      },
      child: Stack(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.themeColorYellow, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              )),
          Center(
              child: Text(
            widget.item.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          )),
          isSelected
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.black,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
