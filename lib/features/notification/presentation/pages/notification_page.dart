import 'package:flutter/material.dart';
import '../../../ticket/presentation/pages/ticket_detail_page.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy notifications
    final notifications = [
      {
        'id': 'ticket_001',
        'title': 'Your ticket has been assigned',
        'description': 'Technician Budi Santoso has been assigned to your ticket',
        'time': '2 hours ago',
      },
      {
        'id': 'ticket_002',
        'title': 'Ticket status updated',
        'description': 'Your printer issue ticket is now In Progress',
        'time': '4 hours ago',
      },
      {
        'id': 'ticket_003',
        'title': 'New ticket confirmation',
        'description': 'Your network problem ticket has been received',
        'time': '1 day ago',
      },
      {
        'id': 'ticket_004',
        'title': 'Ticket completed',
        'description': 'Your monitor issue has been resolved',
        'time': '2 days ago',
      },
      {
        'id': 'ticket_005',
        'title': 'Comment added',
        'description': 'Technician Siti added a comment to your ticket',
        'time': '3 days ago',
      },
    ];

    return Scaffold(
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.notifications, color: Colors.blue),
                    ),
                    title: Text(
                      notification['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(notification['description']!),
                        const SizedBox(height: 4),
                        Text(
                          notification['time']!,
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              TicketDetailPage(ticketId: notification['id']!),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
