import 'dart:io';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> result;
  final String imagePath;
  ResultScreen({required this.result, required this.imagePath});
  @override State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool saving = false;

  Future<void> _save() async {
    setState(() => saving = true);
    final fs = Provider.of<FirestoreService>(context, listen: false);
    await fs.saveRecord(widget.result, widget.imagePath);
    setState(() => saving = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Salvo no seu histórico')));
  }

  @override Widget build(BuildContext context) {
    final items = (widget.result['items'] as List<dynamic>?) ?? [];
    return Scaffold(
      appBar: AppBar(title: Text('Resultado')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.file(File(widget.imagePath), height:220, fit: BoxFit.cover),
          SizedBox(height:12),
          Text('Total: ${widget.result['total_kcal']} kcal', style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
          SizedBox(height:8),
          ...items.map((it) => ListTile(
            title: Text(it['name']),
            subtitle: Text('Porção: ${it['portion_g']}g • ${it['kcal']} kcal'),
            trailing: Text('${(it['confidence']*100).toStringAsFixed(0)}%'),
          )),
          SizedBox(height:12),
          ElevatedButton.icon(
            onPressed: saving ? null : _save,
            icon: Icon(Icons.save),
            label: saving ? Text('Salvando...') : Text('Salvar no histórico')
          ),
          SizedBox(height:12),
          ElevatedButton(
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            child: Text('Voltar ao início')
          )
        ]),
      ),
    );
  }
}
