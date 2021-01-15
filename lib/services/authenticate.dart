import 'package:firebase_auth/firebase_auth.dart';
import 'package:we/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //stream for changes in auth state (sign in, sign out, etc.)
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //return current user id
  String getCurrentUserID(){
    return _auth.currentUser.uid;
  }


  //register w email and password
  Future registerWithEmailAndPassword (String email, String password, String username, String phone) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password

      );

      User user = userCredential.user;
      //FOR EMAIL VERIFICATION
      await user.sendEmailVerification();
      await DatabaseService().createUserData(user.uid, username, email, phone);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  //sign in w email and password
  Future signInWithEmailAndPassword (String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

    } catch (e) {
      print (e.toString());
    }
  }

  //sign out
  Future signOut () async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //password reset
  Future resetPassword (String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}



