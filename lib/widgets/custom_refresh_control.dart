import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRefreshControl extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Color primaryColor;

  const CustomRefreshControl({
    super.key,
    required this.onRefresh,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      refreshIndicatorExtent: 50.0,
      refreshTriggerPullDistance: 70.0,
      builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
        final double percentageComplete = (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);
        final bool isAnimating = refreshState == RefreshIndicatorMode.refresh || refreshState == RefreshIndicatorMode.done;
        
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: BouncingDotsIndicator(
              color: primaryColor,
              isAnimating: isAnimating,
              pullPercentage: percentageComplete,
            ),
          ),
        );
      },
    );
  }
}

class BouncingDotsIndicator extends StatefulWidget {
  final Color color;
  final bool isAnimating;
  final double pullPercentage;

  const BouncingDotsIndicator({
    super.key,
    required this.color,
    this.isAnimating = true,
    this.pullPercentage = 1.0,
  });

  @override
  State<BouncingDotsIndicator> createState() => _BouncingDotsIndicatorState();
}

class _BouncingDotsIndicatorState extends State<BouncingDotsIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double offset = (index * 0.2);
        double progress = _controller.value - offset;
        if (progress < 0) progress += 1.0;
        
        double opacity = 0.2;
        if (progress < 0.5) {
          opacity = 1.0 - (progress / 0.5) * 0.8;
        } else {
          opacity = 0.2 + ((progress - 0.5) / 0.5) * 0.8;
        }
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Icon(
            Icons.circle,
            size: 10.0,
            color: widget.color.withOpacity(opacity.clamp(0.0, 1.0)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only show the dots if pullPercentage is greater than a small threshold
    // so they don't appear when fully scrolled up.
    if (widget.pullPercentage < 0.05 && !widget.isAnimating) {
      return const SizedBox(height: 10);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => _buildDot(index)),
    );
  }
}
