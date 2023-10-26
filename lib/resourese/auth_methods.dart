
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_delivery_app/models/user_model.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static final DatabaseReference _userReference =
      _database.reference().child("Users");


  Future<User> getCurrentUser() async {
    User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser!;
  }


  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges().map((user) => user);
  }


  Future<UserCredential> handleSignInEmail(
      String email, String password) async {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: email, password: password);

    assert(userCredential.user != null);
    final User? currentUser = _auth.currentUser;
    assert(userCredential.user?.uid == currentUser?.uid);

    print('signInEmail succeeded: $userCredential');

    return userCredential;
  }


  Future<UserCredential> handleSignUp(phone, email, password) async {
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      await addDataToDb(userCredential.user!, email, phone, password);
    }
    return userCredential;
  }


  Future<void> addDataToDb(
      User currentUser, String username, String phone, String password) async {
    UserModel user = UserModel(
        uid: currentUser.uid,
        email: currentUser.email,
        phone: phone,
        password: password);

    _userReference.child(currentUser.uid).set(user.toMap(user));
  }


  Future<void> logout() async {
    await _auth.signOut();
  }
}
