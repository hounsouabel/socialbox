import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: MasonryGridView.builder(
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(), // Allow scrolling
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) =>
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                      'assets/person' + (index + 1).toString() + '.jpg'
                  )
              ),
            ),
      ),
    );
  }
}