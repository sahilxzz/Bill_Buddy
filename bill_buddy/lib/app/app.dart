import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp (
            home: Scaffold(
                appBar: AppBar(
                    title: const Text("Bill Buddy"),
                    backgroundColor: const Color(0xFFe5d4ef)
                ),
                body: const Center(
                    child: Text("Welcome to Bill Buddy!"),
                ),
            ),
        );
    }
}