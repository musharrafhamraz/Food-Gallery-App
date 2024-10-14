import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget backgroundImage;
  const BackgroundWidget({super.key, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.2,
              image: AssetImage('assets/images/background.jpg'))),
      child: backgroundImage,
    );
  }
}
