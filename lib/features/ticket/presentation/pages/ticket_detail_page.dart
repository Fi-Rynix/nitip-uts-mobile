import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/ticket_provider.dart';
import '../../data/repositories/ticket_repository.dart';
import '../../data/repositories/technician_repository.dart';
import '../../data/models/comment_model.dart';

class TicketDetailPage extends ConsumerStatefulWidget {
  final String ticketId;

  const TicketDetailPage({Key? key, required this.ticketId}) : super(key: key);

  @override
  ConsumerState<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends ConsumerState<TicketDetailPage> {
  late TextEditingController _commentController;
  final _ticketRepo = TicketRepository();
  final _techRepo = TechnicianRepository();

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final ticketAsync = ref.watch(ticketDetailProvider(widget.ticketId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Detail'),
        centerTitle: true,
      ),
      body: ticketAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (ticket) {
          if (ticket == null) {
            return const Center(child: Text('Ticket not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ticket ID and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ticket.id,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(ticket.status),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        ticket.status.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  ticket.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Description
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(ticket.description),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Ticket info
                _InfoRow(label: 'Created by', value: ticket.createdBy),
                _InfoRow(label: 'Created at', value: _formatDate(ticket.createdAt)),
                if (ticket.assignedTo != null)
                  _InfoRow(label: 'Assigned to', value: ticket.assignedTo!),
                const SizedBox(height: 16),
                // Admin actions
                if (currentUser?.role == 'admin') ...[
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Admin Actions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // Assign technician
                  const Text('Assign Technician:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FutureBuilder(
                    future: _techRepo.getTechnicians(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (!snapshot.hasData) return const Text('No technicians available');

                      final technicians = snapshot.data!;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: technicians
                              .map(
                                (tech) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ticket.assignedTo == tech.username
                                          ? Colors.blue
                                          : Colors.grey[300],
                                    ),
                                    onPressed: () {
                                      _ticketRepo.assignTicketToTechnician(
                                        ticket.id,
                                        tech.username,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Ticket assigned to ${tech.name}',
                                          ),
                                        ),
                                      );
                                      ref.refresh(ticketDetailProvider(widget.ticketId));
                                    },
                                    child: Text(tech.name),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Change status
                  const Text('Change Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _StatusButton(
                          label: 'Open',
                          isActive: ticket.status == 'open',
                          onTap: () {
                            _ticketRepo.updateTicketStatus(ticket.id, 'open');
                            ref.refresh(ticketDetailProvider(widget.ticketId));
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatusButton(
                          label: 'In Progress',
                          isActive: ticket.status == 'in_progress',
                          onTap: () {
                            _ticketRepo.updateTicketStatus(ticket.id, 'in_progress');
                            ref.refresh(ticketDetailProvider(widget.ticketId));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _StatusButton(
                          label: 'Done',
                          isActive: ticket.status == 'done',
                          onTap: () {
                            _ticketRepo.updateTicketStatus(ticket.id, 'done');
                            ref.refresh(ticketDetailProvider(widget.ticketId));
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatusButton(
                          label: 'Cancelled',
                          isActive: ticket.status == 'cancelled',
                          onTap: () {
                            _ticketRepo.updateTicketStatus(ticket.id, 'cancelled');
                            ref.refresh(ticketDetailProvider(widget.ticketId));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                // Comments section
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Comments list
                if (ticket.comments.isEmpty)
                  Text(
                    'No comments yet',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                else
                  Column(
                    children: ticket.comments
                        .map(
                          (comment) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      comment.author,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _formatDate(comment.createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(comment.content),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 16),
                // Add comment
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        final newComment = Comment(
                          id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
                          author: currentUser?.username ?? 'Unknown',
                          content: _commentController.text,
                          createdAt: DateTime.now(),
                        );
                        _ticketRepo.addCommentToTicket(ticket.id, newComment);
                        _commentController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comment added')),
                        );
                        ref.refresh(ticketDetailProvider(widget.ticketId));
                      }
                    },
                    child: const Text('Post Comment'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.red;
      case 'assigned':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'done':
        return Colors.green;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : Colors.grey[300],
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}
