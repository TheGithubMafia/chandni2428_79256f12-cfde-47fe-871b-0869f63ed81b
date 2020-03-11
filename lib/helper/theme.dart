import 'package:flutter/material.dart';


List<BoxShadow>  shadow = <BoxShadow>[BoxShadow(blurRadius: 10,offset: Offset(5, 5),color: AppTheme.apptheme.accentColor,spreadRadius:1)];
String get description { return '';}
TextStyle get onPrimaryTitleText { return  TextStyle(color: Colors.white,fontWeight: FontWeight.w600);}
TextStyle get onPrimarySubTitleText { return  TextStyle(color: Colors.white,);}
BoxDecoration softDecoration =  BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(blurRadius: 8,offset: Offset(5, 5),color: Color(0xffe2e5ed),spreadRadius:5),
              BoxShadow(blurRadius: 8,offset: Offset(-5,-5),color: Color(0xffffffff),spreadRadius:5)
              ],
              color: Color(0xfff1f3f6)
          );
TextStyle get titleStyle { return  TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold,);}
TextStyle get subtitleStyle { return  TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.bold);}
TextStyle get userNameStyle { return  TextStyle(color: AppColor.darkGrey,fontSize: 14,fontWeight: FontWeight.bold);}

class TwitterColor {
  static final Color bondiBlue = Color.fromRGBO(0, 132, 180, 1.0);
  static final Color cerulean = Color.fromRGBO(0, 172, 237, 1.0);
  static final Color spindle = Color.fromRGBO(192, 222, 237, 1.0);
  static final Color white = Color.fromRGBO(255, 255, 255, 1.0);
  static final Color black = Color.fromRGBO(0, 0, 0, 1.0);
  static final Color woodsmoke = Color.fromRGBO(20, 23, 2, 1.0);
  static final Color woodsmoke_50 = Color.fromRGBO(20, 23, 2, 0.5);
  static final Color mystic = Color.fromRGBO(230, 236, 240, 1.0);
  static final Color dodgetBlue = Color.fromRGBO(29, 162, 240, 1.0);
  static final Color dodgetBlue_50 = Color.fromRGBO(29, 162, 240, 0.5);
  static final Color paleSky = Color.fromRGBO(101, 119, 133, 1.0);
  static final Color ceriseRed = Color.fromRGBO(224, 36, 94, 1.0);
  static final Color paleSky50 = Color.fromRGBO(101, 118, 133, 0.5);
}

class AppColor{
  static final Color primary = Color(0xff1DA1F2);
  static final Color secondary = Color(0xff14171A);
  static final Color darkGrey = Color(0xff1657786);
  static final Color lightGrey = Color(0xffAAB8C2);
  static final Color extraLightGrey = Color(0xffE1E8ED);
  static final Color extraExtraLightGrey = Color(0xfF5F8FA);
  static final Color white = Color(0xFFffffff);
}
class AppTheme{
  static final ThemeData apptheme = ThemeData(
    primarySwatch: Colors.blue,
    // fontFamily: 'HelveticaNeue',
    backgroundColor: Colors.white,
    accentColor: TwitterColor.dodgetBlue,
    brightness: Brightness.light,
    primaryColor: AppColor.primary,
    cardColor: Colors.white,
    unselectedWidgetColor: Colors.grey,
    bottomAppBarColor: Colors.white,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColor.white
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Colors.white,
      elevation: 0,
      textTheme:  TextTheme(
        title: TextStyle(
          color: Colors.black,
          fontSize: 26,
          fontStyle: FontStyle.normal),
        )),
      // textTheme:  TextTheme(
      //   title:    TextStyle(color: Colors.black,  fontSize: 20),
      //   body1:    TextStyle(color: Colors.black87,fontSize: 14),
      //   body2:    TextStyle(color: Colors.black87,fontSize: 18),
      //   button:   TextStyle(color: Colors.white,  fontSize: 20),
      //   caption:  TextStyle(color: Colors.black45,fontSize: 16),
      //   headline: TextStyle(color: Colors.black87,fontSize: 26),
      //   subhead:  TextStyle(color: Colors.black,  fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Opensans-Bold'),
      //   subtitle: TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Opensans-Bold'),
      //   display1: TextStyle(color: Colors.black87,fontSize: 14),
      //   display2: TextStyle(color: Colors.black87,fontSize: 18),
      //   display3: TextStyle(color: Colors.black87,fontSize: 22),
      //   display4: TextStyle(color: Colors.black87,fontSize: 24),
      //   overline: TextStyle(color: Colors.black87,fontSize: 10),
      //   ),
    
        // typography: Typography(
        //   dense: TextTheme(
        //     title:    TextStyle(color: Colors.black,  fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     body1:    TextStyle(color: Colors.black87,fontSize: 8,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     body2:    TextStyle(color: Colors.black87,fontSize: 10,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     button:   TextStyle(color: Colors.black,  fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     caption:  TextStyle(color: Colors.black45,fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     headline: TextStyle(color: Colors.black87,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     subhead:  TextStyle(color: Colors.black,  fontSize: 20,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     subtitle: TextStyle(color: Colors.black54,fontSize: 22,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     display1: TextStyle(color: Colors.black87,fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     display2: TextStyle(color: Colors.black87,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     display3: TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     display4: TextStyle(color: Colors.black87,fontSize: 22,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //     overline: TextStyle(color: Colors.black87,fontSize: 8,fontWeight: FontWeight.w600,fontFamily: 'Opensans-SemiBold'),
        //   )
        // ),
        // buttonTheme: ButtonThemeData(
        //   buttonColor: Colors.white,
        //   textTheme: ButtonTextTheme.normal,
        //   disabledColor: Colors.grey,
        //   height: 40,
        //   highlightColor: Colors.yellow.shade300,
        //   splashColor: Colors.purpleAccent,
        // ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor:   TwitterColor.dodgetBlue,
        ),
        colorScheme: ColorScheme(
          background: Colors.white,
          onPrimary: Colors.white,
          onBackground: Colors.black,
          onError: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          primary: Colors.blue,
          primaryVariant: Colors.blue,
          secondary: AppColor.secondary,
          secondaryVariant: AppColor.darkGrey,
          surface: Colors.white,
          brightness: Brightness.light
        )
    );
}