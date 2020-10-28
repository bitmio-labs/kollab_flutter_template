import 'helpers/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final blueColor = HexColor('006AB3');
final lhYellow = HexColor('FCC200');
final greenColor = HexColor('68C700');
final grayColor = HexColor('F1F1F1');
final lightGrayColor = HexColor('888888');
final darkGrayColor = HexColor('484848');
final veryLightGrayColor = HexColor('DBDBDB');

class StyleGuide {
  static var shared = StyleGuide();

  // TODO: replace with real color from theme
  Color get _primaryColor {
    return Colors.blue;
  }

  final tabBackgroundColor = grayColor;
  final tabBannerStyle = TextStyle(
      fontSize: 36, fontWeight: FontWeight.w600, color: darkGrayColor);
  final tabIconColor =
      Colors.black; // TinyColor.fromString("#FCC200").darken(3).color;

  final defaultInsets = EdgeInsets.symmetric(vertical: 0, horizontal: 12);

  final sectionTitleStyle = TextStyle(
      fontSize: 17, color: lightGrayColor, fontWeight: FontWeight.w500);
  final checklistStyle = TextStyle(fontSize: 17, color: lightGrayColor);
  final sectionTitleBottomSpacing = 12.0;

  final textStyle =
      TextStyle(fontSize: 17, fontFamily: 'Arial', color: darkGrayColor);

  //final navigationBarButtonColor = darkGrayColor;

  final progressLabelStyle =
      TextStyle(fontSize: 30, color: greenColor, fontWeight: FontWeight.w500);

  final cardListSpacing = 3.0;
  final cardMessageStyle = TextStyle(
      fontSize: 17, color: darkGrayColor, fontWeight: FontWeight.w500);
  final cardTitleStyle = TextStyle(
      fontSize: 17, color: darkGrayColor, fontWeight: FontWeight.w500);
  Color get cardIconColor {
    return _primaryColor;
  }

  final cardIconTitleSpacing = 12.0;
  final cardTitlePropertySpacing = 6.0;
  final cardPropertyStyle = TextStyle(
      fontSize: 17, color: lightGrayColor, fontWeight: FontWeight.w400);
  final cardPropertyIconColor = lightGrayColor;
  final defaultCardInsets = EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  final cardCheckedColor = greenColor;
  final cardCheckedBackgroundColor = veryLightGrayColor;

  final propertyListLabelStyle = TextStyle(
      fontSize: 17, color: lightGrayColor, fontWeight: FontWeight.w400);
  final propertyListInteractiveValueStyle =
      TextStyle(fontSize: 17, color: blueColor, fontWeight: FontWeight.w500);
  final propertyListValueStyle = TextStyle(
      fontSize: 17, color: lightGrayColor, fontWeight: FontWeight.w500);

  final defaultButtonTitleStyle =
      TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600);
  Color get defaultButtonColor {
    return _primaryColor;
  }

  final buttonInsets =
      EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 15);
  TextStyle get alternativeButtonTitleStyle {
    return TextStyle(fontSize: 17, color: _primaryColor);
  }

  final altenativeButtonColor = Colors.white;
  final textButtonTitleStyle =
      TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600);
}
