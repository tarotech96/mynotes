import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final double width;
  final double height;
  final double strokeWidth;
  const LoadingView(
      {Key? key,
      required this.width,
      required this.height,
      required this.strokeWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: CircularProgressIndicator(
          color: const Color.fromARGB(255, 255, 255, 254),
          strokeWidth: strokeWidth,
          valueColor: const AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}
