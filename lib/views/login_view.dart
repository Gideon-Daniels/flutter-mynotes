import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
// create controllers for text
  late final TextEditingController _email;
  late final TextEditingController _password;
// create state for text
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
// dispose state for text

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is UserNotFoundAuthExcpetion){
                  await showErrorDialog(context, 'User ot found');
                } else if (state.exception is WrongPasswordAuthException){
                  await showErrorDialog(context, 'Wrong credentials');
                } else if (state.exception is GenericAuthException) {
                  await showErrorDialog(context, 'Authentication error');
                }
              }
            },
            child: TextButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[400],
                onPrimary: Colors.white,
                minimumSize: const Size(40, 40),
              ),
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                 context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
              },
              child: const Text('Login'),
            ),
          ),
          // ElevatedButton.icon(
          //   style: ElevatedButton.styleFrom(
          //     primary: Colors.blue[400],
          //     onPrimary: Colors.white,
          //     minimumSize: const Size(40, 40),
          //   ),
          //   onPressed: () async {
          //     final provider =
          //         Provider.of<GoogleSignInProvider>(context, listen: false);
          //     await provider.googleLogin();
          //     final user = AuthService.firebase().currentUser;
          //     final userInfo = FirebaseAuth.instance.currentUser;
          //     print(userInfo);
          //     if (user?.isEmailVerified ?? false) {
          //       // users email is verified
          //       Navigator.of(context).pushNamedAndRemoveUntil(
          //         notesRoute,
          //         (route) => false,
          //       );
          //     }
          //   },
          //   icon: const FaIcon(
          //     FontAwesomeIcons.google,
          //     color: Colors.red,
          //   ),
          //   label: const Text('Sign in with Google'),
          // ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not Registered yet? Register her!'),
          ),
        ],
      ),
    );
  }

  // signin without firebase

  // Future signIn() async {
  //   final user = await GoogleSignInApi.login();

  //   if (user == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Sign In Failed'),
  //       ),
  //     );
  //   } else {
  //     print(user);
  //   }
  // }
}
