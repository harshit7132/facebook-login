import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main()=> runApp(FacebookAuthExample());

class FacebookAuthExample extends StatefulWidget {
  @override
  _FacebookAuthExampleState createState() => _FacebookAuthExampleState();
}

class _FacebookAuthExampleState extends State<FacebookAuthExample> {
  Map<String, dynamic>? _userData;
  bool _isLoggedIn = false;

  // Facebook Login Function
  Future<void> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        setState(() {
          _userData = userData;
          _isLoggedIn = true;
        });
      } else {
        print('Facebook login failed: ${result.message}');
      }
    } catch (e) {
      print('Error during Facebook login: $e');
    }
  }

  // Facebook Logout Function
  Future<void> logoutFromFacebook() async {
    await FacebookAuth.instance.logOut();
    setState(() {
      _userData = null;
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  Scaffold(
        appBar: AppBar(title: Text('Facebook Login Example')),
        body: Center(
          child: _isLoggedIn
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_userData != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(_userData!['picture']['data']['url']),
                  radius: 40,
                ),
              SizedBox(height: 10),
              Text('Name: ${_userData!['name']}'),
              Text('Email: ${_userData!['email']}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: logoutFromFacebook,
                child: Text('Logout'),
              ),
            ],
          )
              : ElevatedButton(
            onPressed: loginWithFacebook,
            child: Text('Login with Facebook'),
          ),
        ),
      ),
    );
  }
}
