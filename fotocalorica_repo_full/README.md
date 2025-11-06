# FotoCalórica - Projeto (scaffold)

Este repositório contém um scaffold do aplicativo **FotoCalórica** (Flutter) e um backend MVP (FastAPI) para inferência de calorias a partir de fotos.

**O que está incluído**
- Código Flutter (pastas `lib/`): telas principais, serviços para API, Firebase e compras in-app.
- Backend (`backend/server.py`): endpoint `/api/infer` que usa CLIP (zero-shot) para identificar alimentos e uma base nutricional simples.
- Instruções de configuração e deploy.

## Como começar (resumo rápido)

### Backend (inferência)
1. Entre na pasta `backend`
2. Crie um ambiente Python: `python -m venv venv && source venv/bin/activate` (Linux/macOS) ou `venv\Scripts\activate` (Windows)
3. `pip install -r requirements.txt`
4. Execute: `python server.py`
5. O endpoint estará em `http://localhost:8000/api/infer`

> Observação: o servidor baixará o modelo CLIP na primeira execução (é normal). Para produção use GPU ou quantize o modelo.

### App Flutter (desenvolvimento)
1. Instale Flutter: https://flutter.dev/docs/get-started/install
2. No root do projeto (onde está `pubspec.yaml`) rode `flutter pub get`
3. Gere `firebase_options.dart` com `flutterfire configure` (veja docs do Firebase)
4. Rodar em dispositivo: `flutter run`

### Notas importantes
- Configure a URL do backend em `lib/src/services/api_service.dart` (substitua 'https://seu-servidor.com').
- Configure produtos de assinatura (`fotocalorica_monthly`) no Google Play Console e App Store Connect.
- Para produção, implemente validação de recibos no servidor e regras de segurança no Firestore.

