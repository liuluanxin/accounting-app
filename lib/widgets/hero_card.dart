import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class HeroCard extends StatelessWidget {
  final String label;
  final String amount;
  final String incomeText;
  final String expenseText;

  const HeroCard({
    super.key,
    required this.label,
    required this.amount,
    required this.incomeText,
    required this.expenseText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 180,
      decoration: AppTheme.heroCardDecoration,
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          // 装饰星星
          ...List.generate(3, (i) {
            final positions = [
              const Offset(0.2, 0.15),
              const Offset(0.7, 0.1),
              const Offset(0.5, 0.6),
            ];
            return Positioned(
              left: positions[i].dx * 280,
              top: positions[i].dy * 140,
              child: _StarDot(delay: i * 1.0),
            );
          }),
          // 右上角装饰文字
          const Positioned(
            right: 10,
            top: 10,
            child: Text(
              '✦ ✧ ★ ✦ ✧',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 16,
                letterSpacing: 6,
              ),
            ),
          ),
          // 右下角装饰圆
          Positioned(
            right: -40,
            bottom: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x4DFFD99E),
              ),
            ),
          ),
          // 内容
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_filled,
                      size: 14, color: AppTheme.textMain),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMain,
                    ),
                  ),
                ],
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(incomeText,
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textMain)),
                  Text(expenseText,
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textMain)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StarDot extends StatefulWidget {
  final double delay;
  const _StarDot({required this.delay});

  @override
  State<_StarDot> createState() => _StarDotState();
}

class _StarDotState extends State<_StarDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(_animation.value),
          ),
        );
      },
    );
  }
}
