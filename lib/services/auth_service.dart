import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthService {

  // Google Sign In
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //sign in
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // checking if the user exists in firestore
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
    final docSnapshot = await userDoc.get();

    // adding the user to Firestore if it doesn't exists
    if(!docSnapshot.exists) {
      await userDoc.set({
        'emaail':userCredential.user!.email,
        'role':'user',
      });
    }
    return userCredential;
    
  }
}