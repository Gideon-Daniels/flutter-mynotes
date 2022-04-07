import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/provider/google_sign_in.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:provider/provider.dart';
import 'views/login_view.dart';
import 'views/notes/create_update_note_view.dart';
import 'views/notes/notes_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({Key? key}) : super(key: key);
  static const String title = 'Main Page';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(FirebaseAuthProvider()),
            child: const HomePage(),
          ),
          routes: {
            loginRoute: (context) => const LoginView(),
            registerRoute: (context) => const RegisterView(),
            notesRoute: (context) => const NotesView(),
            verifyEmailRoute: (context) => const VerifyEmailView(),
            createOrUpdateNewNoteRoute: (context) =>
                const CreateUpdateNotesView(),
          },
        ),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
