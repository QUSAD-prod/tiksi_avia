import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tiksi_avia/components/button.dart';
import 'package:tiksi_avia/components/form.dart';
import 'package:tiksi_avia/components/input.dart';
import 'package:tiksi_avia/components/route_aware.dart';
import 'package:tiksi_avia/components/text.dart';
import 'package:tiksi_avia/pages/account_page.dart';

import 'fb.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends RouteAwareState<AuthPage> {
  late Fb fb;

  bool? _keyboardInvisible;
  bool _modalPageVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resetpasswordController =
      TextEditingController();

  late FocusNode emailFocus;
  late FocusNode passwordFocus;
  late FocusNode resetPasswordFocus;

  String emailFieldError = "";
  String passwordFieldError = "";

  @override
  void initState() {
    super.initState();
    fb = Fb();
    emailFocus = FocusNode(debugLabel: 'emailFocus');
    passwordFocus = FocusNode(debugLabel: 'passwordFocus');
    resetPasswordFocus = FocusNode(debugLabel: 'resetPasswordFocus');
    _emailController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
      setState(() {});
    });
    _resetpasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    resetPasswordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _resetpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (!_modalPageVisible) {
      _keyboardInvisible = MediaQuery.of(context).viewInsets.bottom == 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Вход в аккаунт"),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset(
                "assets/back_arrow.svg",
                color: Theme.of(context).appBarTheme.iconTheme!.color,
                height: 28,
                width: 28,
              ),
              iconSize: 28,
              splashRadius: 20,
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: _keyboardInvisible! ? width * 0.35 : width * 0.2,
                  width: _keyboardInvisible! ? width * 0.35 : width * 0.2,
                  child: Image.asset(
                    'assets/tiksiAviaBig.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              AutofillGroup(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: FormItem(
                        title: 'Email',
                        error: emailFieldError,
                        child: Input(
                          hint: 'Email',
                          controller: _emailController,
                          isPass: false,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: emailFocus,
                          errorEnabled: emailFieldError != "",
                          onSubmit: (String text) {
                            emailFocus.unfocus();
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                          onTap: () {
                            setState(() {
                              emailFieldError = "";
                            });
                          },
                          autofillHints: const [
                            AutofillHints.username,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: FormItem(
                        title: 'Пароль',
                        error: passwordFieldError,
                        child: Input(
                          hint: 'Пароль',
                          controller: _passwordController,
                          isPass: true,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          focusNode: passwordFocus,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(18),
                          ],
                          errorEnabled: passwordFieldError != "",
                          onSubmit: (String text) {
                            passwordFocus.unfocus();
                            signIn();
                          },
                          onTap: () {
                            setState(() {
                              passwordFieldError = "";
                            });
                          },
                          autofillHints: const [AutofillHints.password],
                          onEditingComplete: () =>
                              TextInput.finishAutofillContext(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Button(
                        text: 'Войти',
                        onClick: () => signIn(),
                        mode: ButtonMode.primary,
                        active: _emailController.text != "" &&
                            _passwordController.text != "",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Забыли пароль? ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Button(
                    text: 'Восстановить',
                    onClick: () =>
                        resetPasswordModalPage(context, height, width),
                    mode: ButtonMode.text,
                  ),
                ],
              ),
              AnimatedContainer(
                height: MediaQuery.of(context).viewInsets.bottom == 0.0
                    ? 0.0
                    : MediaQuery.of(context).viewInsets.bottom - height * 0.01,
                duration: const Duration(milliseconds: 150),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> signIn() async {
    FocusScope.of(context).unfocus();
    await fb.signIn(_emailController.text, _passwordController.text).then(
      (value) {
        switch (value) {
          case 'ok':
            showSnackBar(
              context: context,
              text: "Вы успешно вошли в аккаунт",
              icon: SvgPicture.asset(
                "assets/icon_done.svg",
                color: const Color(0xFF4BB34B),
              ),
            );
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const AccountPage(),
              ),
            );
            break;
          case 'invalid-email':
          case 'user-not-found':
          case 'wrong-password':
            setState(() {
              emailFieldError = "Неверный логин или пароль";
              passwordFieldError = "Неверный логин или пароль";
            });
            showSnackBar(
              context: context,
              text: "Неверный логин или пароль",
              icon: SvgPicture.asset(
                "assets/icon_cancel.svg",
                color: const Color(0xFFE64646),
              ),
            );
            break;
          case 'network-request-failed':
            showSnackBar(
              text: "Нет подключения к интернету",
              icon: SvgPicture.asset(
                "assets/icon_globe_cross_outline.svg",
                color: const Color(0xFFE64646),
              ),
              context: context,
            );
            break;
          case 'too-many-requests':
            showSnackBar(
              text: "Слишком много попыток входа",
              icon: SvgPicture.asset(
                "assets/icon_cancel.svg",
                color: const Color(0xFFE64646),
              ),
              context: context,
            );
            break;
          default:
            showSnackBar(
              text: "Неизвестная ошибка",
              icon: SvgPicture.asset(
                "assets/icon_cancel.svg",
                color: const Color(0xFFE64646),
              ),
              context: context,
            );
        }
      },
    );
  }

  resetPasswordModalPage(
    BuildContext context,
    double height,
    double width,
  ) async {
    FocusScope.of(context).unfocus();
    Timer(
      const Duration(milliseconds: 150),
      () async => {
        _modalPageVisible = true,
        await showBarModalBottomSheet(
          context: context,
          topControl: Container(),
          builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBar(
                      title: const Text(
                        "Восстановить пароль",
                      ),
                      leading: Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: SvgPicture.asset(
                              "assets/back_arrow.svg",
                              color: Theme.of(context)
                                  .appBarTheme
                                  .iconTheme!
                                  .color,
                              height: 28,
                              width: 28,
                            ),
                            iconSize: 28,
                            splashRadius: 20,
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 16.0,
                        bottom: 16.0,
                        left: width * 0.025,
                        right: width * 0.025,
                      ),
                      child: Input(
                        hint: 'Email',
                        controller: _resetpasswordController,
                        isPass: false,
                        focusNode: resetPasswordFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [
                          AutofillHints.email,
                          AutofillHints.username,
                        ],
                        onChanged: (String text) {
                          setState(() {});
                        },
                        onSubmit: (String text) {
                          resetPasswordFocus.unfocus();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 16.0,
                        left: width * 0.025,
                        right: width * 0.025,
                      ),
                      child: Button(
                        text: 'Восстановить',
                        onClick: () async {
                          FocusScope.of(context).unfocus();
                          await fb
                              .resetPassword(_resetpasswordController.text)
                              .then(
                            (value) {
                              switch (value) {
                                case 'ok':
                                  showSnackBar(
                                    context: context,
                                    text:
                                        "Письмо для сброса пароля успешно отправлено на ваш email",
                                    icon: SvgPicture.asset(
                                      "assets/icon_done.svg",
                                      color: const Color(0xFF4BB34B),
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                  break;
                                case 'network-request-failed':
                                  showSnackBar(
                                    text: "Нет подключения к интернету",
                                    icon: SvgPicture.asset(
                                      "assets/icon_globe_cross_outline.svg",
                                      color: const Color(0xFFE64646),
                                    ),
                                    context: context,
                                  );
                                  Navigator.of(context).pop();
                                  break;
                                case 'user-not-found':
                                  showSnackBar(
                                    text: "Неверно указан email",
                                    icon: SvgPicture.asset(
                                      "assets/icon_cancel.svg",
                                      color: const Color(0xFFE64646),
                                    ),
                                    context: context,
                                  );
                                  Navigator.of(context).pop();
                                  break;
                                default:
                                  showSnackBar(
                                    text: "Неизвестная ошибка",
                                    icon: SvgPicture.asset(
                                      "assets/icon_cancel.svg",
                                      color: const Color(0xFFE64646),
                                    ),
                                    context: context,
                                  );
                                  Navigator.of(context).pop();
                              }
                            },
                          );
                        },
                        active: EmailValidator.validate(
                            _resetpasswordController.text),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 16.0,
                        left: width * 0.025,
                        right: width * 0.025,
                      ),
                      child: SecondaryText(
                        text: EmailValidator.validate(
                                _resetpasswordController.text)
                            ? "После нажатия кнопки, вам на почту будет выслано письмо со ссылкой для восстановления доступа к аккаунту."
                            : "Заполните поле чтобы продолжить",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    AnimatedContainer(
                      height: MediaQuery.of(context).viewInsets.bottom == 0.0
                          ? 0.0
                          : MediaQuery.of(context).viewInsets.bottom,
                      duration: const Duration(milliseconds: 150),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).whenComplete(() {
          _modalPageVisible = false;
          _resetpasswordController.clear();
        }),
      },
    );
  }

  showSnackBar({
    required String text,
    Widget? icon,
    required BuildContext context,
  }) {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: icon == null
          ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)
          : const EdgeInsets.only(
              left: 12.0, right: 16.0, top: 12.0, bottom: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      content: Row(
        children: [
          Container(
            margin: icon == null
                ? const EdgeInsets.all(0.0)
                : const EdgeInsets.only(right: 12.0),
            child: icon ?? const SizedBox(width: 0, height: 0),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void onEnterScreen() {}

  @override
  void onLeaveScreen() {}
}
