// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/isolate_provider.dart';
import '../classes/result_class.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isolateProvider = Provider.of<IsolateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate and FileService Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isolateProvider.isLoading) const LinearProgressIndicator(),
            if (isolateProvider.errorMessage != null)
              Text(
                'Error: ${isolateProvider.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Result<String> createResult =
                    await isolateProvider.createTestJson();
                if (createResult.isSuccess) {
                  _showResult(context, 'Create Status', createResult.data!);
                } else {
                  _showError(context, createResult.error.toString());
                }
              },
              child: const Text('Create test.json'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Result<String> readResult =
                    await isolateProvider.readTestJson();
                if (readResult.isSuccess) {
                  _showResult(context, 'File Content', readResult.data!);
                } else {
                  _showError(context, readResult.error.toString());
                }
              },
              child: const Text('Read test.json'),
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context, String title, String result) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
