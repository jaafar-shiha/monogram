import 'package:flutter/material.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/Constants/app_styles.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final Function() onTap;
  const SettingCard({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
              ),
              width: double.infinity,
              child: ListTile(
                title: Text(
                  title,
                  style: AppStyles.h2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
