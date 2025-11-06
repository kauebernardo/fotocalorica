import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/purchase_service.dart';

class SubscribeScreen extends StatelessWidget {
  @override Widget build(BuildContext context) {
    final purchase = Provider.of<PurchaseService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Assinatura Premium')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Text('FotoCalórica Premium', style: TextStyle(fontSize:22, fontWeight: FontWeight.bold)),
          SizedBox(height:8),
          Text('Assinatura mensal — recursos premium:\n• Resultados ilimitados\n• Histórico completo\n• Sem anúncios', textAlign: TextAlign.center),
          SizedBox(height:16),
          ElevatedButton(
            onPressed: () => purchase.buyMonthly(),
            child: Text('Assinar mensal (R\$ 14,90/mês)'),
          ),
          if (purchase.isLoading) Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()),
          SizedBox(height:12),
          TextButton(child: Text('Restaurar compras'), onPressed: () => purchase.restorePurchases())
        ]),
      ),
    );
  }
}
