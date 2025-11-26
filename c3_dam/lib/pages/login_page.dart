import 'package:c3_dam/constants.dart';
import 'package:c3_dam/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String msgError = '';
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(kSecondary), Color(kPrimary)]),
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 250),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Bienvenido a "),
                      Text("TicketPunto", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: OutlinedButton.icon(
                    icon: Icon(MdiIcons.account, color: Colors.red),
                    label: Text('Iniciar con Google'),
                    onPressed: () async {
                      setState(() {
                        msgError = '';
                      });

                      try {
                        final cred = await _authService.signInWithGoogle();

                        if (cred == null) {
                          setState(() {
                            msgError = "Inicio de sesión cancelado";
                          });
                        }
                      } catch (e) {
                        debugPrint("Google Sign-In error: $e");
                        setState(() {
                          msgError = "Error al iniciar con Google. Revisa SHA-1/SHA-256 y google-services.json";
                        });
                      }
                    },
                  ),
                ),
                Container(
                  child: Text(
                    msgError,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
