import 'package:flutter/material.dart';

/// Enhanced Splash Screen optimized for custom app icons - Full Screen responsive
class EnhancedSplashScreen extends StatefulWidget {
  final Duration displayDuration;
  final VoidCallback onComplete;
  final String customIconPath;
  final String appTitle;
  final String appSubtitle;

  const EnhancedSplashScreen({
    super.key,
    this.displayDuration = const Duration(seconds: 3),
    required this.onComplete,
    required this.customIconPath,
    this.appTitle = 'MINI GAMER',
    this.appSubtitle = 'Action. Challenge. Thrill.',
  });

  @override
  State<EnhancedSplashScreen> createState() => _EnhancedSplashScreenState();
}

class _EnhancedSplashScreenState extends State<EnhancedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashTimer();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  void _startSplashTimer() {
    Future.delayed(widget.displayDuration, () {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) {
            widget.onComplete();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildIconImage() {
    try {
      return Image.asset(
        widget.customIconPath,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('🔴 Image.asset error: $error');
          debugPrint('Path: ${widget.customIconPath}');
          debugPrint('Stack: $stackTrace');
          return _buildFallbackIcon();
        },
      );
    } catch (e) {
      debugPrint('🔴 Exception loading icon: $e');
      return _buildFallbackIcon();
    }
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: const Color(0xFF5C6BC0),
      child: const Icon(
        Icons.gamepad,
        color: Colors.white,
        size: 60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF101A2B),
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Premium gradient background - full screen
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF101A2B),
                      const Color(0xFF1A2942),
                      const Color(0xFF162033),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Animated background decorative elements
            Positioned(
              top: -80,
              right: -80,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF5C6BC0).withValues(alpha: 0.08),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5C6BC0).withValues(alpha: 0.1),
                        blurRadius: 40,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -100,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFC857).withValues(alpha: 0.05),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFC857).withValues(alpha: 0.1),
                        blurRadius: 60,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main content - centered and responsive
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Custom App Icon with Scale animation
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5C6BC0)
                                    .withValues(alpha: 0.4),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: _buildIconImage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),

                      // App Title with slide animation
                      Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Column(
                          children: [
                            Text(
                              widget.appTitle,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2.5,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFF5C6BC0),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.appSubtitle,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB8C7D9),
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),

                      // Modern Loading Indicator
                      Transform.translate(
                        offset: Offset(0, _slideAnimation.value * 2),
                        child: const ModernLoadingIndicator(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernLoadingIndicator extends StatefulWidget {
  const ModernLoadingIndicator({super.key});

  @override
  State<ModernLoadingIndicator> createState() => _ModernLoadingIndicatorState();
}

class _ModernLoadingIndicatorState extends State<ModernLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Modern Pulse Loader
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsing ring
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (_controller.value * 0.4),
                    child: Opacity(
                      opacity: (1 - _controller.value),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF5C6BC0),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Middle pulsing ring
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.9 + (_controller.value * 0.3),
                    child: Opacity(
                      opacity: (1 - _controller.value * 0.7),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFFC857),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Center dot
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFC857),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFC857),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Animated loading text
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final dots = '.' * ((_controller.value * 3).toInt() % 4);
            return Text(
              'Loading$dots',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFB8C7D9),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ],
    );
  }
}
