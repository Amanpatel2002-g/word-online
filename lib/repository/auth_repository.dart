import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:wordonline/constants.dart';
import 'package:wordonline/local_stroage.dart';
import 'package:wordonline/models/user_model.dart';
import 'package:wordonline/providers/user_provider.dart';

import '../screens/home_screen.dart';

final authRepositoryProvider = Provider(
    (ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: Client()));

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  AuthRepository({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;
  Future<void> signInWithGoogle(WidgetRef ref, BuildContext context) async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
            email: user.email,
            name: user.displayName!,
            token: '',
            uid: '',
            profilePic: user.photoUrl!);
        var res = await _client.post(Uri.parse('$host/api/signup'),
            body: userAcc.toJson(),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            });
        switch (res.statusCode) {
          case 200:
            final userfromApi = UserModel.fromJson(res.body);
            ref.read(userProvider.notifier).setUser(userfromApi);
            final token = userfromApi.token;
            LocalStorage.setString(tokenKey, token);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => true);
            break;
          case 401:
            print(res.body);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool?> getUserDataWithToken(WidgetRef ref) async {
    try {
      print('came here');
      final String? token = await LocalStorage.getString(tokenKey);
      if (token == null) return false;
      var res = await _client
          .get(Uri.parse('$host/'), headers: {
        'content-type': 'application/json; charset=UTF-8',
        tokenKey: token
      });
      final UserModel user = UserModel.fromJson(res.body);
      ref.read(userProvider.notifier).setUser(user);
      return true;
    } catch (e) {
      print("got an error here");
      print(e.toString());
      return false;
    }
    // return null;
  }
}
