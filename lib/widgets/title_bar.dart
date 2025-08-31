import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        windowManager.startDragging();
      },
      child: Container(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Text(
              'Subscription Guardian',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.minimize),
              onPressed: () => windowManager.minimize(),
            ),
            IconButton(
              icon: const Icon(Icons.crop_square),
              onPressed: () => windowManager.maximize(),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => windowManager.close(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
