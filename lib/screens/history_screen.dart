import 'package:flutter/material.dart';
import '../services/database_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final db = await DatabaseService().database;
    return await db.query('calculations', orderBy: 'timestamp DESC');
  }

  Future<void> _clearHistory() async {
    final db = await DatabaseService().database;
    try {
      await db.delete('calculations');
      setState(() {
        _historyFuture = _fetchHistory();
      });
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm deletion'),
          content: Text('Are you sure you want to delete the history?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculations history'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool? confirmDelete = await _showDeleteConfirmationDialog(context);
              if (confirmDelete == true) {
                await _clearHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('History cleared')),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final history = snapshot.data!;
          if (history.isEmpty) {
            return Center(
              child: Text(
                'History is empty',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final calculation = item['calculation'] ?? '';
              final timestamp = item['timestamp'] ?? '';
              return ListTile(
                title: Text(
                  calculation,
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}