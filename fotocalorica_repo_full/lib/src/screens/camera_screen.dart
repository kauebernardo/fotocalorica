import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'result_screen.dart';
import '../services/api_service.dart';

class CameraScreen extends StatefulWidget {
  @override State<CameraScreen> createState() => _CameraScreenState();
}
class _CameraScreenState extends State<CameraScreen> {
  XFile? _image;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) setState(() => _image = picked);
  }

  Future<void> _sendToServer() async {
    if (_image == null) return;
    setState(() => _loading = true);
    try {
      final api = ApiService();
      final res = await api.analyzeImage(File(_image!.path));
      // res contém JSON com items e total_kcal
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ResultScreen(result: res, imagePath: _image!.path)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally { setState(() => _loading = false); }
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tirar foto')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          _image == null
            ? Container(height:300, color: Colors.grey[100], child: Center(child: Text('Nenhuma foto')))
            : Image.file(File(_image!.path), height:300, fit: BoxFit.cover),
          SizedBox(height:12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(onPressed: _takePhoto, icon: Icon(Icons.camera_alt), label: Text('Tirar foto')),
            SizedBox(width:12),
            ElevatedButton.icon(onPressed: _sendToServer, icon: Icon(Icons.send), label: _loading ? Text('Enviando...') : Text('Analisar'),)
          ]),
          SizedBox(height:12),
          Text('Dica: inclua um garfo/colher para referência de escala')
        ]),
      ),
    );
  }
}
