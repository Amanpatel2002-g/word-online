import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordonline/providers/user_provider.dart';
import 'package:wordonline/repository/auth_repository.dart';
import 'package:wordonline/screens/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool? isPresent;
  void getUserData() async {
    isPresent =
        await ref.read(authRepositoryProvider).getUserDataWithToken(ref);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isPresent == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : isPresent == true
                ? Scaffold(
                    body: Center(child: Text(ref.watch(userProvider).token)),
                  )
                : const LoginScreen()
        // home: const LoginScreen(),
        );
  }
}
// flutter run -d chrome --web-port 3000