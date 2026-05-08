import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        children: [
          Container(color: AppColors.navy),
          Positioned(
            right: -33,
            top: -5,
            child: Container(
              width: 153,
              height: 153,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange12,
              ),
            ),
          ),
          Positioned(
            left: 70,
            bottom: -21,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange12,
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 34,
            child: Image.asset(AppAssets.bell, width: 42, height: 42),
          ),
          Positioned(
            left: 20,
            top: 77,
            child: RichText(
              text: const TextSpan(
                style: AppTextStyles.logo,
                children: [
                  TextSpan(text: 'Bengkel'),
                  TextSpan(
                    text: 'Track',
                    style: TextStyle(color: AppColors.orange),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 20,
            top: 116,
            child: Text('Halo, fahmi!', style: AppTextStyles.body),
          ),
          const Positioned(
            left: 20,
            top: 135,
            child: Text(
              'Butuh Bantuan Mekanik?',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 163,
            child: Container(
              height: 25,
              padding: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                color: AppColors.orange20,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: AppColors.peach, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'Lamongan, Jawa Timur',
                    style: TextStyle(
                      color: AppColors.peach,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
