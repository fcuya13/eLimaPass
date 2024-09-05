import 'package:flutter/material.dart';

class CarBackground extends StatelessWidget {
  const CarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Image(
          image: AssetImage('assets/home.jpeg'),
          height: double.infinity,
          fit: BoxFit.fitHeight,
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0XFF08305f).withOpacity(0.5),
          ),
          width: double.infinity,
        )
      ],
    );
  }
}
