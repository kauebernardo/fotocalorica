import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'subscribe_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Text('Usuário: ${auth.currentUser?.email ?? "anônimo"}'),
          SizedBox(height:12),
          ElevatedButton(child: Text('Assinatura Premium'), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SubscribeScreen()))),
          SizedBox(height:12),
          ElevatedButton(child: Text('Sair'), onPressed: () async { await auth.signOut(); Navigator.of(context).popUntil((r)=>r.isFirst); })
        ]),
      ),
    );
  }
}
