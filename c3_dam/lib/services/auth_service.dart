import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // v7.x: singleton obligado
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleInit = false;

  Future<void> _ensureGoogleInit() async {
    if (_googleInit) return;
    await _googleSignIn.initialize(); // requerido en 7.x
    _googleInit = true;
  }

  Future<UserCredential?> signInWithGoogle() async {
    await _ensureGoogleInit();

    try {
      // 1) Selector de cuenta (v7.x)
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // 2) Pedir scopes para obtener accessToken (v7.x)
      const scopes = ['email', 'profile'];
      final authz = await googleUser.authorizationClient.authorizationForScopes(scopes) ?? await googleUser.authorizationClient.authorizeScopes(scopes);

      final accessToken = authz.accessToken;

      // 3) idToken viene desde authentication (sin await en 7.x)
      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw Exception("No se pudo obtener idToken de Google");
      }

      // 4) Credencial para Firebase
      final credential = GoogleAuthProvider.credential(idToken: idToken, accessToken: accessToken);

      // 5) Login en Firebase
      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      // cancelado / error Google
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
