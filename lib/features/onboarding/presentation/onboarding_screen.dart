import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_theme.dart';

/// Introductory onboarding flow for first-time users.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentSlide = 0;

  final List<_OnboardingSlideData> _slides = const [
    _OnboardingSlideData(
      title: 'Track Your Spending',
      description:
          'Manage daily expenses and income with elegant, real-time ledgers.',
      tag: 'Daily Control',
      gradientA: AppColors.primary,
      gradientB: AppColors.primaryContainer,
      amount: '-\$86.20',
      caption: 'Dining Out',
    ),
    _OnboardingSlideData(
      title: 'Plan Your Future',
      description:
          'Create budgets that forecast your month before money leaves.',
      tag: 'Budgeting',
      gradientA: AppColors.secondary,
      gradientB: Color(0xFF009B8A),
      amount: '+\$1,240',
      caption: 'Monthly Income',
    ),
    _OnboardingSlideData(
      title: 'Insightful Analytics',
      description:
          'See category patterns and weekly trends in one beautiful glance.',
      tag: 'Insights',
      gradientA: AppColors.tertiary,
      gradientB: Color(0xFFB8522F),
      amount: '72%',
      caption: 'Budget Efficiency',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'The Financial Atelier',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(RouteNames.auth),
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentSlide = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(22, 10, 22, 22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _IllustrationCard(slide: slide),
                        const SizedBox(height: 22),
                        Text(
                          slide.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 8),
                width: index == _currentSlide ? 32 : 8,
                height: 6,
                decoration: BoxDecoration(
                  color: index == _currentSlide
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _onNextPressed,
              icon: const Icon(Icons.arrow_forward),
              label: Text(
                _currentSlide == _slides.length - 1 ? 'Get Started' : 'Next',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onNextPressed() async {
    if (_currentSlide >= _slides.length - 1) {
      if (!mounted) {
        return;
      }
      context.go(RouteNames.auth);
      return;
    }

    await _pageController.animateToPage(
      _currentSlide + 1,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }
}

class _IllustrationCard extends StatelessWidget {
  const _IllustrationCard({required this.slide});

  final _OnboardingSlideData slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [slide.gradientA, slide.gradientB],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -24,
            child: Container(
              width: 146,
              height: 146,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.14),
              ),
            ),
          ),
          Positioned(
            left: -26,
            bottom: -34,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            top: 22,
            left: 22,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.onPrimary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                slide.tag,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onPrimary,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const Center(
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 84,
              color: AppColors.onPrimary,
            ),
          ),
          Positioned(
            left: 18,
            bottom: 18,
            child: _MiniFinanceCard(
              title: slide.caption,
              value: slide.amount,
              icon: Icons.trending_up,
              alignEnd: false,
            ),
          ),
          Positioned(
            right: 18,
            top: 70,
            child: _MiniFinanceCard(
              title: 'Weekly',
              value: '7 entries',
              icon: Icons.bar_chart,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniFinanceCard extends StatelessWidget {
  const _MiniFinanceCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.alignEnd,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.title,
    required this.description,
    required this.tag,
    required this.gradientA,
    required this.gradientB,
    required this.amount,
    required this.caption,
  });

  final String title;
  final String description;
  final String tag;
  final Color gradientA;
  final Color gradientB;
  final String amount;
  final String caption;
}
