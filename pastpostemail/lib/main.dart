import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      print('An error occurred configuring Amplify: $e');
    }
  }

  bool isSignUpComplete = false;

  Future<void> signUpUser() async {
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: 'gersan1997@hotmail.com',
        CognitoUserAttributeKey.phoneNumber: '+573013382345',
        // additional attributes as needed
      };
      final result = await Amplify.Auth.signUp(
        username: 'germancitosegundo',
        password: 'mysupersecurepassword',
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );
      setState(() {
        isSignUpComplete = result.isSignUpComplete;
      });
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> confirmUser() async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: 'germancitosegundo', confirmationCode: '567605');

      setState(() {
        isSignUpComplete = result.isSignUpComplete;
      });
    } on AuthException catch (e) {
      print(e.message);
    }
  }

// Create a boolean for checking the sign in status
  bool isSignedIn = false;

  Future<void> signInUser(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      print('Resultado');
      print(result.nextStep);
      fetchAuthSession();
      setState(() {
        isSignedIn = result.isSignedIn;
      });
    } on AuthException catch (e) {
      print('Hubo un error wntrando');
      print(e.message);
    }
  }

  Future<void> fetchAuthSession() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      String identityId = (result as CognitoAuthSession).identityId!;
      print('identityId: $identityId');
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signOutUser() async {
    try {
      final result = await Amplify.Auth.signOut();
      setState(() {
        print('Result');
        print(result);
        isSignedIn = !isSignedIn;
      });
    } on AuthException catch (e) {
      print('Hubo un error wntrando');
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Column(
        children: [
          TextButton(
            onPressed: () async => {signUpUser()},
            child: Text('TextButton'),
          ),
          TextButton(
            onPressed: () async =>
                {signInUser('germancitosegundo', 'mysupersecurepassword')},
            child: Text('Sign in'),
          ),
          TextButton(
            onPressed: () async => {signOutUser()},
            child: Text('Sign out'),
          ),
          TextButton(
            onPressed: () async => {confirmUser()},
            child: Text('Confirm'),
          ),
        ],
      ))),
    );
  }
}
