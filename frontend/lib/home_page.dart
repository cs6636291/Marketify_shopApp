import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 14),
            const SizedBox(height: 14,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context, 
                  '/mylistPage',
                );
              },
              child: const Text('My list page'),
            ),
          ],
        ),
      ),
    );
  }
}