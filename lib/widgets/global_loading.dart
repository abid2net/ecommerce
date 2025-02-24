import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ecommerce/constants/constants.dart';

class GlobalLoading extends StatelessWidget {
  const GlobalLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black.withAlpha(10),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: SizedBox(
              height: 70,
              width: 70,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: AppConstants.loadingColors,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
