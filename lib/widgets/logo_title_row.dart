import 'package:flutter/material.dart';

/// A reusable widget that displays a logo and a title in a row layout.
/// The dimension can be controlled with the below parameters
///
/// [logoWidth]- width of sized box enclosing the logo
/// [logoHeight]- height of sized box enclosing the logo
/// [titleText]- the text to be place beside the logo
/// [textSize]- of the text place beside the logo
/// [spacerWidth]- of the sized box between the logo and title
class LogoTitleRow extends StatelessWidget {
  final double logoWidth;
  final double logoHeight;
  final String titleText;
  final double textSize;
  final double spacerWidth;

  const LogoTitleRow({
    super.key,
    required this.logoWidth,
    required this.logoHeight,
    required this.titleText,
    required this.textSize,
    required this.spacerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: logoWidth,
          height: logoHeight,
          child: Image.asset('assets/images/logo_2.png'), // Hardcoded logo path
        ),
        SizedBox(width: spacerWidth),
        Text(
          titleText, // Hardcoded title
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
