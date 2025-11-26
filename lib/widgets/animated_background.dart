import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _particlesController;
  late Animation<Color?> _color1Animation;
  late Animation<Color?> _color2Animation;
  late Animation<Color?> _color3Animation;

  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Initialize gradient animation
    _gradientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _color1Animation = ColorTween(
      begin: const Color(0xFF0F172A),
      end: const Color(0xFF1E1B4B),
    ).animate(_gradientController);

    _color2Animation = ColorTween(
      begin: const Color(0xFF1E293B),
      end: const Color(0xFF312E81),
    ).animate(_gradientController);

    _color3Animation = ColorTween(
      begin: const Color(0xFF0F172A),
      end: const Color(0xFF1E1B4B),
    ).animate(_gradientController);

    // Initialize particles
    _particlesController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Create particles
    for (int i = 0; i < 15; i++) {
      _particles.add(Particle());
    }
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_gradientController, _particlesController]),
      builder: (context, child) {
        // Update particle positions
        for (var particle in _particles) {
          particle.update();
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _color1Animation.value ?? const Color(0xFF0F172A),
                _color2Animation.value ?? const Color(0xFF1E293B),
                _color3Animation.value ?? const Color(0xFF0F172A),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Floating particles
              ..._particles.map((particle) => Positioned(
                left: particle.x,
                top: particle.y,
                child: Opacity(
                  opacity: particle.opacity,
                  child: Container(
                    width: particle.size,
                    height: particle.size,
                    decoration: BoxDecoration(
                      color: particle.color.withOpacity(0.3),
                      shape: particle.shape,
                      borderRadius: particle.shape == BoxShape.rectangle
                          ? BorderRadius.circular(4)
                          : null,
                    ),
                  ),
                ),
              )),
              // Subtle overlay pattern
              CustomPaint(
                painter: GridPainter(),
                size: Size.infinite,
              ),
            ],
          ),
        );
      },
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double size;
  late Color color;
  late BoxShape shape;
  late double opacity;
  late double speedX;
  late double speedY;

  Particle() {
    final random = Random();
    x = random.nextDouble() * 400;
    y = random.nextDouble() * 800;
    size = random.nextDouble() * 8 + 4;
    color = [
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
    ][random.nextInt(5)];
    shape = random.nextBool() ? BoxShape.circle : BoxShape.rectangle;
    opacity = random.nextDouble() * 0.5 + 0.2;
    speedX = random.nextDouble() * 0.5 - 0.25;
    speedY = random.nextDouble() * 0.5 - 0.25;
  }

  void update() {
    x += speedX;
    y += speedY;

    // Wrap around screen
    if (x < -20) x = 420;
    if (x > 420) x = -20;
    if (y < -20) y = 820;
    if (y > 820) y = -20;
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}