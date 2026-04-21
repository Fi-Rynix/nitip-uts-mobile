import '../models/ticket_model.dart';
import '../models/comment_model.dart';

class TicketRepository {
  // Dummy tickets
  static final List<Ticket> _tickets = [
    // User 1 tickets
    Ticket(
      id: 'ticket_001',
      title: "Laptop won't start",
      description: 'My laptop suddenly won\'t turn on anymore',
      status: 'open',
      createdBy: 'user1',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      comments: [
        Comment(
          id: 'comment_001',
          author: 'user1',
          content: 'Please help, I need this urgently',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
    ),
    Ticket(
      id: 'ticket_002',
      title: 'Printer not working',
      description: 'Network printer is not responding',
      status: 'assigned',
      createdBy: 'user1',
      assignedTo: 'budi',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      comments: [
        Comment(
          id: 'comment_002',
          author: 'user1',
          content: 'Already restarted but still not working',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Comment(
          id: 'comment_003',
          author: 'budi',
          content: 'I\'m looking into it, will visit tomorrow',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    ),
    // User 2 tickets
    Ticket(
      id: 'ticket_003',
      title: 'Monitor issue',
      description: 'External monitor showing black screen',
      status: 'in_progress',
      createdBy: 'user2',
      assignedTo: 'siti',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      comments: [
        Comment(
          id: 'comment_004',
          author: 'user2',
          content: 'This is affecting my work',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ],
    ),
    Ticket(
      id: 'ticket_004',
      title: 'Network problem',
      description: 'Internet connection keeps dropping',
      status: 'done',
      createdBy: 'user2',
      assignedTo: 'budi',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      comments: [
        Comment(
          id: 'comment_005',
          author: 'user2',
          content: 'Thanks for fixing this!',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
    Ticket(
      id: 'ticket_005',
      title: 'Software installation',
      description: 'Need Microsoft Office installed on my computer',
      status: 'cancelled',
      createdBy: 'user2',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      comments: [],
    ),
  ];

  /// Get all tickets
  Future<List<Ticket>> getAllTickets() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tickets;
  }

  /// Get tickets by user (created by username)
  Future<List<Ticket>> getTicketsByUser(String username) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tickets.where((t) => t.createdBy == username).toList();
  }

  /// Get ticket by id
  Future<Ticket?> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _tickets.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get tickets filtered by status
  Future<List<Ticket>> getTicketsByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tickets.where((t) => t.status == status).toList();
  }

  /// Update ticket status
  Future<Ticket?> updateTicketStatus(String ticketId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final index = _tickets.indexWhere((t) => t.id == ticketId);
      if (index != -1) {
        _tickets[index] = _tickets[index].copyWith(status: newStatus);
        return _tickets[index];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Assign ticket to technician
  Future<Ticket?> assignTicketToTechnician(
    String ticketId,
    String technicianUsername,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final index = _tickets.indexWhere((t) => t.id == ticketId);
      if (index != -1) {
        _tickets[index] = _tickets[index].copyWith(
          assignedTo: technicianUsername,
          status: 'assigned',
        );
        return _tickets[index];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Add comment to ticket
  Future<Ticket?> addCommentToTicket(String ticketId, Comment comment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final index = _tickets.indexWhere((t) => t.id == ticketId);
      if (index != -1) {
        final currentComments = List<Comment>.from(_tickets[index].comments);
        currentComments.add(comment);
        _tickets[index] = _tickets[index].copyWith(comments: currentComments);
        return _tickets[index];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Create new ticket
  Future<Ticket?> createTicket(
    String title,
    String description,
    String createdBy,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final newTicket = Ticket(
        id: 'ticket_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        status: 'open',
        createdBy: createdBy,
        createdAt: DateTime.now(),
      );
      _tickets.add(newTicket);
      return newTicket;
    } catch (e) {
      return null;
    }
  }
}
