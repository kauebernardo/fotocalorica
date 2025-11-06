import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('FotoCalórica', style: TextStyle(fontSize:32,fontWeight:FontWeight.bold)),
            SizedBox(height:12),
            Text('Tire uma foto da sua refeição e obtenha uma estimativa rápida das calorias.', textAlign: TextAlign.center,),
            SizedBox(height:24),
            ElevatedButton(
              child: Text('Começar (tocar foto)'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CameraScreen())),
            ),
            TextButton(
              child: Text('Entrar / Perfil'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen())),
            )
          ],
        ),
      ),
    );
  }
}
