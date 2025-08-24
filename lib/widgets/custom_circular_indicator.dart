import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CustomCircularLoading extends StatelessWidget{
  const CustomCircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: Container(
            color: Colors.transparent,
          ),
        ),
        const Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }


}