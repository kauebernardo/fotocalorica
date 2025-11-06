import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail(String email, String pass) =>
    _auth.signInWithEmailAndPassword(email: email, password: pass);

  Future<UserCredential> createUser(String email, String pass) =>
    _auth.createUserWithEmailAndPassword(email: email, password: pass);

  Future<void> signOut() => _auth.signOut();
}
