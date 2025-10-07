import 'package:flutter/material.dart';
class HistoryPage extends StatelessWidget {
  final List<String> history;
  const HistoryPage({super.key, required this.history});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: history.isEmpty
          ? const Center(child: Text('No exercises completed yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: history.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.lightGreen[100],
                  child: ListTile(
                    title: Text(history[index]),
                  ),
                );
              },
            ),
    );
  }
}
