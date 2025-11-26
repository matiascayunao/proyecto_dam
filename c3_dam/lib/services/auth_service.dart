import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleInit = false;

  Future<void> _ensureGoogleInit() async {
    if (_googleInit) return;
    await _googleSignIn.initialize();
    _googleInit = true;
  }

  Future<UserCredential?> signInWithGoogle() async {
    await _ensureGoogleInit();

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      const scopes = ['email', 'profile'];
      final authz = await googleUser.authorizationClient.authorizationForScopes(scopes) ?? await googleUser.authorizationClient.authorizeScopes(scopes);

      final accessToken = authz.accessToken;

      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw Exception("No se pudo obtener idToken de Google");
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken, accessToken: accessToken);

      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _ensureGoogleInit();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
