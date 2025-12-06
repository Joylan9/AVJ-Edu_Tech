import 'dart:async';
import 'package:flutter/material.dart';

/// CreateAccountPage
/// - Paste this file as lib/features/auth/create_account.dart
/// - Wire into router as usual (e.g. '/create-account')
///
/// Notes:
/// - No backend calls are included. Hook your API client in `_submit()` where marked.
/// - All important behaviors are implemented so this is testable and production-ready as a starting point.

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // Form & controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  // Focus nodes for better UX / keyboard control
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  // UI state
  bool _agreeTerms = false;
  bool _isSubmitting = false;
  bool _passwordVisible = false;
  bool _confirmVisible = false;

  // Debounce for email validation (avoid revalidating too often)
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Example: live validation / analytics hooks can be attached here
    _emailCtrl.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _emailCtrl.removeListener(_onEmailChanged);

    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();

    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // ---------- Validation helpers (unit-testable) ----------
  static bool isValidEmail(String v) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(v);
  }

  static bool hasMinLength(String v) => v.length >= 8;
  static bool hasUppercase(String v) => v.contains(RegExp(r'[A-Z]'));
  static bool hasNumber(String v) => v.contains(RegExp(r'\d'));
  static bool hasSpecialChar(String v) =>
      v.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  int passwordStrengthCount(String password) {
    return [
      hasMinLength(password),
      hasUppercase(password),
      hasNumber(password),
      hasSpecialChar(password)
    ].where((e) => e).length;
  }

  String passwordStrengthLabel(String password) {
    final c = passwordStrengthCount(password);
    if (c == 0) return '';
    if (c <= 2) return 'Weak';
    if (c == 3) return 'Medium';
    return 'Strong';
  }

  Color passwordStrengthColor(String password, ThemeData theme) {
    final c = passwordStrengthCount(password);
    if (c <= 2) return theme.colorScheme.error;
    if (c == 3) return Colors.orange;
    return Colors.green;
  }

  // ---------- UX helpers ----------
  void _onEmailChanged() {
    // Debounce email validation for UX; useful when hooking live remote checks later.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() {}); // triggers validators UI updates
    });
  }

  bool get _isFormValid {
    final email = _emailCtrl.text.trim();
    final pw = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;
    final emailOk = email.isNotEmpty && isValidEmail(email);
    final pwOk = hasMinLength(pw) &&
        hasUppercase(pw) &&
        hasNumber(pw) &&
        hasSpecialChar(pw);
    final confirmOk = confirm.isNotEmpty && confirm == pw;
    return emailOk && pwOk && confirmOk && _agreeTerms;
  }

  Future<void> _submit() async {
    // Extra guard
    if (!_formKey.currentState!.validate()) return;
    if (!_isFormValid) return;

    // Save/blur fields
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
    _confirmFocus.unfocus();

    setState(() => _isSubmitting = true);

    try {
      // TODO: Replace this with your API client / repository.
      // Example:
      // final result = await AuthRepository.register(email, password);
      await Future.delayed(const Duration(seconds: 1)); // simulate network

      // TODO: persist tokens securely using flutter_secure_storage if backend returns tokens
      // TODO: navigate to next screen: Navigator.pushReplacementNamed(context, '/profile');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created (dummy flow)')),
        );
      }

      // analytics placeholder
      _logAnalyticsEvent('register_submit', {'method': 'email'});
    } catch (err, st) {
      // Centralize error handling - show friendly error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Sign up failed. Try again. (${err.toString()})')),
        );
      }
      // TODO: send to crash reporting (Sentry) or logging service.
      _logError(err, st);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // Replace with real instrumentation call
  void _logAnalyticsEvent(String name, [Map<String, dynamic>? params]) {
    // Placeholder - integrate firebase/analytics later
    // debugPrint('Analytics: $name - $params');
  }

  // Replace with real error reporting
  void _logError(Object err, StackTrace st) {
    // Placeholder - integrate Sentry/Crashlytics later
    // debugPrint('ERROR: $err\n$st');
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final maxContentWidth = width > 800 ? 700.0 : double.infinity;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                children: [
                  // Header
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create Your Account',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Form
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          // Email
                          TextFormField(
                            controller: _emailCtrl,
                            focusNode: _emailFocus,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'you@email.com',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocus);
                            },
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty)
                                return 'Please enter your email';
                              if (!isValidEmail(value))
                                return 'Please enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            controller: _passwordCtrl,
                            focusNode: _passwordFocus,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter a secure password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() =>
                                      _passwordVisible = !_passwordVisible);
                                },
                                tooltip: _passwordVisible
                                    ? 'Hide password'
                                    : 'Show password',
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            obscureText: !_passwordVisible,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            onChanged: (_) => setState(() {}),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_confirmFocus);
                            },
                            validator: (v) {
                              final value = v ?? '';
                              if (value.isEmpty)
                                return 'Please enter a password';
                              if (!hasMinLength(value))
                                return 'Password must be at least 8 characters';
                              if (!hasUppercase(value))
                                return 'Password must include an uppercase letter';
                              if (!hasNumber(value))
                                return 'Password must include a number';
                              if (!hasSpecialChar(value))
                                return 'Password must include a special character';
                              return null;
                            },
                          ),

                          // Password strength + checklist
                          if (_passwordCtrl.text.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _buildStrengthSection(context),
                          ],

                          const SizedBox(height: 16),

                          // Confirm password
                          TextFormField(
                            controller: _confirmCtrl,
                            focusNode: _confirmFocus,
                            decoration: InputDecoration(
                              labelText: 'Confirm password',
                              hintText: 'Re-enter your password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(
                                      () => _confirmVisible = !_confirmVisible);
                                },
                                tooltip: _confirmVisible
                                    ? 'Hide password'
                                    : 'Show password',
                                icon: Icon(
                                  _confirmVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            obscureText: !_confirmVisible,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.newPassword],
                            onChanged: (_) => setState(() {}),
                            validator: (v) {
                              final value = v ?? '';
                              if (value.isEmpty)
                                return 'Please confirm your password';
                              if (value != _passwordCtrl.text)
                                return 'Passwords do not match';
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Terms
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                container: true,
                                label: 'Agree to terms checkbox',
                                child: Checkbox(
                                  value: _agreeTerms,
                                  onChanged: (v) =>
                                      setState(() => _agreeTerms = v ?? false),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey[800]),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer:
                                            null, // attach GestureRecognizer if you want navigation
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Submit
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isFormValid && !_isSubmitting
                                  ? _submit
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : const Text('Create Account'),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Footer
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // TODO: navigate to login screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Navigate to log in (TODO)')));
                              },
                              child:
                                  const Text('Already have an account? Log in'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Separate builder for strength UI to keep build tidy
  Widget _buildStrengthSection(BuildContext context) {
    final theme = Theme.of(context);
    final pw = _passwordCtrl.text;
    final count = passwordStrengthCount(pw);
    final label = passwordStrengthLabel(pw);
    final color = passwordStrengthColor(pw, theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header (label + indicator)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Password Strength',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.grey[700])),
            Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 6,
            color: Colors.grey.shade300,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (count / 4).clamp(0, 1),
              child: Container(color: color),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // checklist
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              _requirementRow('At least 8 characters', hasMinLength(pw)),
              const SizedBox(height: 8),
              _requirementRow('1 uppercase letter', hasUppercase(pw)),
              const SizedBox(height: 8),
              _requirementRow('1 number', hasNumber(pw)),
              const SizedBox(height: 8),
              _requirementRow(
                  '1 special character (!@#\$…)', hasSpecialChar(pw)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _requirementRow(String label, bool met) {
    final color = met ? Colors.green : Colors.grey;
    return Row(
      children: [
        Icon(met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: met ? Colors.black : Colors.grey[700]))),
      ],
    );
  }
}
