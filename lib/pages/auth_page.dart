import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../components/button.dart';
import '../components/form.dart';
import '../components/input.dart';
import '../components/panel_header.dart';
import '../components/snackbar.dart';
import '../config.dart';
import '../data/avia_repository.dart';
import '../theme/vk_colors.dart';
import '../theme/vk_typography.dart';
import '../utils/navigation.dart';
import 'admin_page.dart';

/// Sign-in for dispatchers who publish the schedule.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // The demo build is pre-filled so the admin part can be opened in one tap.
  final _email = TextEditingController(
    text: AppConfig.demo ? 'dispatcher@tiksi.aero' : '',
  );
  final _password = TextEditingController(
    text: AppConfig.demo ? 'demo-password' : '',
  );
  final _passwordFocus = FocusNode();

  bool _passwordVisible = false;
  bool _loading = false;
  String? _error;

  bool get _canSubmit =>
      _email.text.trim().isNotEmpty && _password.text.isNotEmpty;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_canSubmit || _loading) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await context.read<AviaRepository>().signIn(_email.text, _password.text);
      TextInput.finishAutofillContext();
      if (!mounted) return;
      showVkSnackbar(context, 'Вы вошли как диспетчер');
      replacePage<void>(context, const AdminPage());
    } on RepositoryException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
      if (e.error == RepositoryError.network) showErrorSnackbar(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Scaffold(
      appBar: const VkPanelHeader(title: 'Вход'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    'assets/tiksiAviaBig.png',
                    width: 88,
                    height: 88,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Вход для диспетчера',
                textAlign: TextAlign.center,
                style: VkTypography.title1.copyWith(color: vk.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Добавляйте и редактируйте рейсы — пассажиры увидят изменения на табло сразу',
                textAlign: TextAlign.center,
                style: VkTypography.text.copyWith(color: vk.textSecondary),
              ),
              const SizedBox(height: 20),
              VkFormItem(
                top: 'Email',
                child: VkInput(
                  controller: _email,
                  placeholder: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  autofillHints: const [
                    AutofillHints.username,
                    AutofillHints.email,
                  ],
                  error: _error != null,
                  onChanged: (_) => setState(() => _error = null),
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
              ),
              VkFormItem(
                top: 'Пароль',
                bottom: _error,
                error: true,
                child: VkInput(
                  controller: _password,
                  focusNode: _passwordFocus,
                  placeholder: 'Введите пароль',
                  obscureText: !_passwordVisible,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  error: _error != null,
                  onChanged: (_) => setState(() => _error = null),
                  onSubmitted: (_) => _signIn(),
                  after: IconButton(
                    tooltip: _passwordVisible
                        ? 'Скрыть пароль'
                        : 'Показать пароль',
                    onPressed: () =>
                        setState(() => _passwordVisible = !_passwordVisible),
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 22,
                      color: vk.iconSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              VkButton(
                text: 'Войти',
                stretched: true,
                loading: _loading,
                onPressed: _canSubmit ? _signIn : null,
              ),
              const SizedBox(height: 8),
              Center(
                child: VkButton(
                  text: 'Забыли пароль?',
                  mode: VkButtonMode.tertiary,
                  size: VkButtonSize.m,
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (_) =>
                        _ResetPasswordSheet(initialEmail: _email.text),
                  ),
                ),
              ),
              if (AppConfig.demo) ...[
                const SizedBox(height: 12),
                Text(
                  'Демо-режим: подойдут любые email и пароль',
                  textAlign: TextAlign.center,
                  style: VkTypography.footnote.copyWith(color: vk.textTertiary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResetPasswordSheet extends StatefulWidget {
  const _ResetPasswordSheet({required this.initialEmail});

  final String initialEmail;

  @override
  State<_ResetPasswordSheet> createState() => _ResetPasswordSheetState();
}

class _ResetPasswordSheetState extends State<_ResetPasswordSheet> {
  late final _email = TextEditingController(text: widget.initialEmail);
  bool _loading = false;

  bool get _valid => EmailValidator.validate(_email.text.trim());

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _loading = true);
    final navigator = Navigator.of(context);
    try {
      await context.read<AviaRepository>().resetPassword(_email.text);
      if (!mounted) return;
      showVkSnackbar(
        context,
        'Ссылка для сброса пароля отправлена на ${_email.text.trim()}',
      );
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      showErrorSnackbar(context, e);
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Восстановление пароля',
            style: VkTypography.title2.copyWith(color: vk.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Пришлём на почту ссылку, по которой можно задать новый пароль',
            style: VkTypography.text.copyWith(color: vk.textSecondary),
          ),
          const SizedBox(height: 12),
          VkFormItem(
            top: 'Email',
            child: VkInput(
              controller: _email,
              placeholder: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _valid ? _send() : null,
            ),
          ),
          const SizedBox(height: 12),
          VkButton(
            text: 'Отправить ссылку',
            stretched: true,
            loading: _loading,
            onPressed: _valid ? _send : null,
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
