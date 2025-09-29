import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/task_notification_manager.dart';

class NotificationTestWidget extends StatelessWidget {
  const NotificationTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Test',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Test notification button
            ElevatedButton.icon(
              onPressed: () => _testNotification(context),
              icon: const Icon(Icons.notifications),
              label: const Text('Test Notification'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 16),

            // Show notification permissions status
            FutureBuilder<bool>(
              future: _checkNotificationPermissions(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      Icon(
                        snapshot.data! ? Icons.check_circle : Icons.error,
                        color: snapshot.data! ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        snapshot.data!
                            ? 'Notifications Enabled'
                            : 'Notifications Disabled',
                        style: TextStyle(
                          color: snapshot.data! ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testNotification(BuildContext context) async {
    try {
      await TaskNotificationManager.testNotification();
      _showSnackBar(context, 'Test notification sent!', Colors.green);
    } catch (e) {
      _showSnackBar(context, 'Failed to send notification: $e', Colors.red);
    }
  }

  Future<bool> _checkNotificationPermissions() async {
    try {
      return await NotificationService.requestPermissions();
    } catch (e) {
      return false;
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
