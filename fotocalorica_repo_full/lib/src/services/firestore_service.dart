import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveRecord(Map<String, dynamic> result, String imagePath) async {
    final uid = _auth.currentUser?.uid ?? 'anonymous';
    await _db.collection('users').doc(uid).collection('records').add({
      'result': result,
      'imagePath': imagePath,
      'createdAt': FieldValue.serverTimestamp()
    });
  }
}
