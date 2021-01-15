import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:we/shared/Styles/colors.dart';
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.White,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.Yellow,
            valueColor: new AlwaysStoppedAnimation<Color>(AppColors.lipstick),
        ),
      ),
    );
  }
}
