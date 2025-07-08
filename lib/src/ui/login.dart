import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../router/app_router.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode buttonFocus = FocusNode();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    buttonFocus.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // TODO: Thực hiện xác thực, ở đây chỉ chuyển sang Home
    context.router.replace(const HomeRoute());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      // () async {
      // // Nếu có input đang focus, bỏ focus và không pop
      // if (usernameFocus.hasFocus ||
      //     passwordFocus.hasFocus ||
      //     buttonFocus.hasFocus) {
      //   FocusScope.of(context).unfocus();
      //   return false;
      // }
      // // Nếu không còn input nào focus, cho phép pop
      // return true;
      // },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Shortcuts(
                shortcuts: <LogicalKeySet, Intent>{
                  LogicalKeySet(LogicalKeyboardKey.arrowDown):
                      NextFocusIntent(),
                  LogicalKeySet(LogicalKeyboardKey.tab): NextFocusIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowUp):
                      PreviousFocusIntent(),
                },
                child: Actions(
                  actions: <Type, Action<Intent>>{
                    NextFocusIntent: CallbackAction<NextFocusIntent>(
                      onInvoke: (intent) => FocusScope.of(context).nextFocus(),
                    ),
                    PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
                      onInvoke: (intent) =>
                          FocusScope.of(context).previousFocus(),
                    ),
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: usernameController,
                        focusNode: usernameFocus,
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => passwordFocus.requestFocus(),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        focusNode: passwordFocus,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => buttonFocus.requestFocus(),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        focusNode: buttonFocus,
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
