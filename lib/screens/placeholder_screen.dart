import 'package:flutter/material.dart';

import '../theme.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Екран у розробці 🌙',
                  style: TextStyle(color: AppColors.muted, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
