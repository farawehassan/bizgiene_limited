import 'package:bizgienelimited/styles/theme.dart' as Theme;
import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed});

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        gradient: new LinearGradient(
            colors: [
              Theme.ColorGradients.loginGradientEnd,
              Theme.ColorGradients.loginGradientStart
            ],
            begin: const FractionalOffset(0.2, 0.2),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: RawMaterialButton(
        elevation: 0.0,
        child: Icon(icon, color: Colors.white,),
        onPressed: onPressed,
        constraints: BoxConstraints.tightFor(
          width: 56.0,
          height: 56.0,
        ),
        shape: CircleBorder(),
        //fillColor: Color(0xFF4C4F5E),
      ),
    );
  }
}