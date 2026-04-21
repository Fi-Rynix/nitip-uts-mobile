import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/ticket_provider.dart';
import '../../data/repositories/ticket_repository.dart';
import '../models/ticket_filter_model.dart';
import './ticket_detail_page.dart';
import './create_ticket_page.dart';

class TicketListPage extends ConsumerStatefulWidget {
  const TicketListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends ConsumerState<TicketListPage> {
  late TicketFilter _filter = TicketFilter.all;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final ticketRepo = TicketRepository();

    // Determine which tickets to show based on user role
    final ticketsAsync = currentUser?.role == 'admin'
        ? ref.watch(fetchAllTicketsProvider)
        : ref.watch(userTicketsProvider(currentUser?.username ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _filter == TicketFilter.all,
                  onTap: () => setState(() => _filter = TicketFilter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Open',
                  isSelected: _filter == TicketFilter.open,
                  onTap: () => setState(() => _filter = TicketFilter.open),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Assigned',
                  isSelected: _filter == TicketFilter.assigned,
                  onTap: () => setState(() => _filter = TicketFilter.assigned),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'In Progress',
                  isSelected: _filter == TicketFilter.inProgress,
                  onTap: () => setState(() => _filter = TicketFilter.inProgress),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Done',
                  isSelected: _filter == TicketFilter.done,
                  onTap: () => setState(() => _filter = TicketFilter.done),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Cancelled',
                  isSelected: _filter == TicketFilter.cancelled,
                  onTap: () => setState(() => _filter = TicketFilter.cancelled),
                ),
              ],
            ),
          ),
          // Ticket list
          Expanded(
            child: ticketsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (tickets) {
                // Filter tickets based on selected filter
                final filteredTickets = _filter == TicketFilter.all
                    ? tickets
                    : tickets.where((t) => t.status == _filter.statusValue).toList();

                if (filteredTickets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No tickets found',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = filteredTickets[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TicketDetailPage(ticketId: ticket.id),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ticket ID and Status
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ticket.id,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(ticket.status),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      ticket.status.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Title
                              Text(
                                ticket.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              // Description
                              Text(
                                ticket.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              // Footer: Assigned to and Created by
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'By: ${ticket.createdBy}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  if (ticket.assignedTo != null)
                                    Text(
                                      'To: ${ticket.assignedTo}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.blue,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: currentUser?.role == 'user'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateTicketPage(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
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
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
