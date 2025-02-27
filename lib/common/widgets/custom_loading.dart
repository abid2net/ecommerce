import 'package:ecommerce/common/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    this.size = 50,
    this.isFullScreen = false,
  });

  final double size;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? Scaffold(
          body: Container(
            color: Colors.black.withAlpha(10),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: SizedBox(
                  height: size,
                  width: size,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballRotateChase,
                    colors: AppConstants.loadingColors,
                  ),
                ),
              ),
            ),
          ),
        )
        : Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: SizedBox(
              height: size,
              width: size,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: AppConstants.loadingColors,
              ),
            ),
          ),
        );
  }
}
