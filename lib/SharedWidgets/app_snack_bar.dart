import 'package:flutter/material.dart';
import 'package:monogram/Constants/app_colors.dart';

SnackBar appSnackBar({required String text}) =>
    SnackBar(
      backgroundColor: AppColors.grey,
      content: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );