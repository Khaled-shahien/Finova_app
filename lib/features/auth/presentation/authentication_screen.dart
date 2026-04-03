import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/route_names.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';

/// Authentication screen aligned with design assets.
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.05),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildMobileBrand(),
                      const SizedBox(height: 28),
                      _buildFormCard(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBrand() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryContainer],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.onPrimary,
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'The Atelier',
          style: const TextStyle(fontSize: 52 / 2, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 34, 28, 26),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isRegisterMode ? 'Create Account' : 'Welcome Back',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              'Sign in to your atelier to manage your assets.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 38),
            _sectionLabel('EMAIL ADDRESS'),
            const SizedBox(height: 10),
            _buildInput(
              controller: _emailController,
              icon: Icons.mail,
              hintText: 'name@company.com',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required.';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email address.';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionLabel('PASSWORD'),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot?',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            _buildInput(
              controller: _passwordController,
              icon: Icons.lock,
              hintText: '........',
              obscureText: _obscurePassword,
              suffix: IconButton(
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.outline,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required.';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isRegisterMode ? 'Create Account' : 'Sign In',
                      style: const TextStyle(
                        fontSize: 22 / 2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR CONTINUE WITH',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.outline,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: _socialButton(
                    icon: Icons.g_mobiledata,
                    text: 'Google',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _socialButton(icon: Icons.apple, text: 'Apple'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    _isRegisterMode
                        ? 'Already have an account? '
                        : 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _isRegisterMode = !_isRegisterMode);
                    },
                    child: Text(
                      _isRegisterMode ? 'Sign In' : 'Create an Atelier',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        letterSpacing: 3,
        fontWeight: FontWeight.w700,
        fontSize: 32 / 2,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.outline),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _socialButton({required IconData icon, required String text}) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.surfaceContainerHigh,
        foregroundColor: AppColors.onSurface,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      icon: Icon(icon),
      label: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isRegisterMode) {
        await AuthService.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await AuthService.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (!mounted) {
        return;
      }
      context.go(RouteNames.home);
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
