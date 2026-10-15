// Teaching helper for demos 1 and 5: makes rebuilds VISIBLE.
//
// A rebuild takes about a millisecond and looks like nothing happened.
// Each widget calls BuildCounter.count(...) at the top of build() and shows
// the number in a BuildTag. The tag flashes yellow every time build() runs.
import 'package:flutter/material.dart';

class BuildCounter {
  static final Map<String, int> _counts = {};

  /// Adds 1 to [name]'s counter and returns the new value.
  static int count(String name) => _counts[name] = (_counts[name] ?? 0) + 1;

  static void reset() => _counts.clear();
}

class BuildTag extends StatelessWidget {
  const BuildTag(this.builds, {super.key});

  final int builds;

  @override
  Widget build(BuildContext context) {
    // A new key each time the number changes restarts the flash animation.
    return TweenAnimationBuilder<double>(
      key: ValueKey(builds),
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 900),
      builder: (context, flash, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Color.lerp(Colors.grey.shade300, Colors.yellow, flash),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
      child: Text(
        'built $builds×',
        style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
      ),
    );
  }
}
