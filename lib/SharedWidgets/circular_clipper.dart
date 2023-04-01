import 'package:flutter/material.dart';

class CircularClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 250, 250);
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}