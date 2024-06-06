import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task/Core/Services/cache_helper.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/calendar',
    ]
  );

  Future<User?> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      print('userCredential ${userCredential.user}');
      CacheHelper.put(key: 'uId', value: userCredential.user!.uid);
      CacheHelper.put(key: 'accessToken', value: googleAuth.accessToken);
      return userCredential.user;
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }
}
