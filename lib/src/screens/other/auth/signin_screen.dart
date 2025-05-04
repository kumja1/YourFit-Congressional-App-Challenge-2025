import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:yourfit/src/app_router.dart';
import 'package:yourfit/src/utils/constants/constants.dart';
import 'package:yourfit/src/utils/constants/images.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AppRouter _router = getIt<AppRouter>();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldState =
      GlobalKey<ScaffoldMessengerState>();
  late TextEditingController _email;
  late TextEditingController _password;
  bool _passwordVisible = false;

  bool _isSignInDisabled = false;


  _togglePasswordVisible() => _passwordVisible = !_passwordVisible;

  _buildForm() {
    return Column(
      children: [
        Row(
          spacing: 30,         
          mainAxisSize: MainAxisSize.min,
          children: [
            NiceButtons(
              onTap: () => {},
              borderColor: Colors.grey,
              endColor: Colors.white,
              startColor: Colors.white,

              width: 50,
              height: 50,
              stretch: false,
              child: const Image(image: Images.googleLogo),
            ),
              NiceButtons(
              onTap: () => {},
              borderColor: Colors.grey,
              endColor: Colors.white,
              startColor: Colors.white,
              width: 100,
              height: 50,
              stretch: false,
              child: const Image(image: Images.googleLogo),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Form(
          key: _formState,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 360,
                child: TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    floatingLabelStyle: TextStyle(color: Colors.blueAccent),
                    hoverColor: Colors.blue,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (val) => "",
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 360,
                child: Stack(
                  children: [
                    TextFormField(
                      controller: _password,
                      obscureText: !_passwordVisible,
                      decoration: const InputDecoration(
                        label: Text("Password"),
                        floatingLabelStyle: TextStyle(color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () => _togglePasswordVisible(),
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: Colors.blue,
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Positioned(
          top: 5,
          bottom: 5,
          left: 5,
          child: Align(
            alignment: const Alignment(0.8, 0),
            child: TextButton(
              onPressed: () => _router.navigatePath("/reset_password_screen"),
              style: const ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.blue),
                ),
              ),
              child: const Text(
                "Reset Password",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        NiceButtons(
          disabled: _isSignInDisabled,
          onTap: (Function finish) async => {finish()},
          startColor: Colors.blueAccent,
          width: 300,
          stretch: false,
          height: 40,
          progress: true,
          borderRadius: 10,
          child: const Text(
            "Sign in",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Sign in", style: TextStyle(fontSize: 30)),
          const SizedBox(height: 30.0),
          _buildForm(),

          const SizedBox(height: 20),
          Align(
            alignment: const Alignment(0, 7),
            child: Text.rich(
              TextSpan(
                text: "New User? ",
                children: [
                  TextSpan(
                    text: "Get Started",
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationThickness: 3,
                      decorationColor: Colors.blue,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap =
                              () async =>
                                  await _router.navigatePath("/signup_screen"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }
}
