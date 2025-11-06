import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Entrar')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _email, decoration: InputDecoration(labelText:'Email')),
          TextField(controller: _pass, decoration: InputDecoration(labelText:'Senha'), obscureText: true),
          SizedBox(height:12),
          ElevatedButton(
            onPressed: () async {
              setState(() => loading = true);
              try {
                await auth.signInWithEmail(_email.text.trim(), _pass.text.trim());
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProfileScreen()));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              } finally { setState(() => loading = false); }
            },
            child: loading ? CircularProgressIndicator() : Text('Entrar')
          ),
          TextButton(
            child: Text('Criar conta'),
            onPressed: () async {
              try {
                await auth.createUser(_email.text.trim(), _pass.text.trim());
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProfileScreen()));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          )
        ]),
      ),
    );
  }
}
