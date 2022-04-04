import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static const _clientIDWeb =
      "435719764446-voe8sc4rrvs8rd60mksk5j93t69ogrq3.apps.googleusercontent.com";

  static final _googleSignIn = GoogleSignIn(clientId: _clientIDWeb);

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}
