import 'package:flutter/material.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we/shared/size_config.dart';

class AppStyles {
  static final fontfamily = GoogleFonts.montserrat();
  static TextStyle appTextHeading2(Color inputColor, FontWeight ft) {
    return GoogleFonts.montserrat(
        fontSize: SizeConfig.safeBlockHorizontal*6, fontWeight: ft, color: inputColor);
  }
  static TextStyle appTextHeading(Color inputColor, FontWeight ft) {
    return GoogleFonts.montserrat(
        fontSize: SizeConfig.safeBlockHorizontal*5, fontWeight: ft, color: inputColor);
  }

  static TextStyle appTextRegular(Color inputColor) {
    return GoogleFonts.montserrat(
        fontSize: SizeConfig.safeBlockHorizontal*4, fontWeight: FontWeight.w200, color: inputColor);
  }

  static BoxDecoration bottomNavBarStyling() {
    return BoxDecoration(boxShadow: [
      BoxShadow(color: AppColors.lipstick),
    ]);
  }

  static iconStyling(IconData icon, Color inputColor) {
    return IconButton(
      icon: Icon(
        icon,
        size: SizeConfig.safeBlockHorizontal*7,
        color: inputColor,
      ),
    );
  }
}
