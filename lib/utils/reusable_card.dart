import 'package:bizgienelimited/utils/size_config.dart';
import 'package:flutter/material.dart';

/// A [ReusableCard] StatelessWidget class to build a card
class ReusableCard extends StatelessWidget {
  ReusableCard({this.cardChild, this.onPress});

  final String cardChild;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: onPress,
      child: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              cardChild,
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        margin: EdgeInsets.all(8.0),
      ),
    );
  }

}

/// A [ProfileCard] StatelessWidget class to build a dynamic profile card
class ProfileCard extends StatelessWidget {

  ProfileCard({this.cardChild});

  final Widget cardChild;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cardChild,
      ),
    );
  }

}


/// A [SelectCard] StatelessWidget class to build a dynamic select card
class SelectCard extends StatelessWidget {

  SelectCard({
    @required this.text1,
    @required this.text2,
    this.onPress,
    @required this.isSelected
  });

  final String text1;
  final String text2;
  final Function onPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: 150,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        text1,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        text2,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.check_circle,
                    color: isSelected ? Color(0xFF008752) : Colors.grey[400],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}