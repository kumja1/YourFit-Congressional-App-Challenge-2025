import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:text_divider/text_divider.dart';
import 'package:yourfit/src/app_router.dart';
import 'package:yourfit/src/utils/constants/constants.dart';

@routePage
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
    return Center(
      child: Column(
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
                width: 100,
                height: 50,
                stretch: false,
                child: const Icon(FontAwesomeIcons.google)
              ),
              NiceButtons(
                onTap: () => {},
                borderColor: Colors.grey,
                endColor: Colors.white,
                startColor: Colors.white,
                width:  100,
                height: 50,
                stretch: false,
                child: const Icon(FontAwesomeIcons.apple)
              ),
              NiceButtons(
                onTap: () => {},
                borderColor: Colors.grey,
                endColor: Colors.white,
                startColor: Colors.white,
                width:  100,
                height: 50,
                stretch: false,
                child: const Icon(FontAwesomeIcons.facebook)
              ),
            ],
          ),
          const SizedBox(height: 15),
          const SizedBox(
            width: 420,
            child: TextDivider(
              text: Text(
                "OR",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formState,
            child: Column(
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
                          floatingLabelStyle: TextStyle(
                            color: Colors.blueAccent,
                          ),
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
          const SizedBox(height: 20),
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
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => _router.navigatePath("/reset_password_screen"),
            style: const ButtonStyle(
              textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.blue)),
            ),
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
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
          const SizedBox(height: 60.0),
          _buildForm(),
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
