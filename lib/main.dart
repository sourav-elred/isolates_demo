import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isolates_demo/services/socket_service.dart';
import 'package:isolates_demo/viewModels/data_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataViewModel()),
        Provider<SocketService>(
          create: (context) => SocketService()..initializeSocket(),
          dispose: (context, socketService) => socketService.socket.dispose(),
        ),
      ],
      child: const MaterialApp(home: MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Future<void> _performHeavyComputation(BuildContext context) async {
    try {
      final result = await platform.invokeMethod('performHeavyComputation');
      // ignore: use_build_context_synchronously
      Provider.of<DataViewModel>(context, listen: false)
          .updateMessage('Heavy Computation Result: $result');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to perform heavy computation: ${e.message}");
      }
    }
  }

  final platform = const MethodChannel('com.example.heavy_computation');

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataViewModel>(context);
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Received Message: ${dataProvider.message}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                socketService.sendMessage('Hello from Flutter!');
              },
              child: const Text('Send Message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _performHeavyComputation(context),
              child: const Text('Perform Heavy Computation'),
            ),
          ],
        ),
      ),
    );
  }
}
