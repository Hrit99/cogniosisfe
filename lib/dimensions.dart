import 'package:flutter/material.dart';

double getWidth(BuildContext context, double px) {
  double screenWidth = MediaQuery.of(context).size.width;
  return (px / 402) * screenWidth;
}

double getHeight(BuildContext context, double px) {
  double screenHeight = MediaQuery.of(context).size.height;
  return (px / 874) * screenHeight;
}
