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
            padding: EdgeInsets.all(40.0),
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
      shadowColor: Color(0xFF004C7F),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cardChild,
      ),
    );
  }

}
