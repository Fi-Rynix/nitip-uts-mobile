import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/ticket_repository.dart';
import '../providers/ticket_provider.dart';
import 'camera_screen.dart';

class CreateTicketPage extends ConsumerStatefulWidget {
  const CreateTicketPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends ConsumerState<CreateTicketPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isSubmitting = false;
  final _ticketRepo = TicketRepository();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleCreateTicket() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final currentUser = ref.read(currentUserProvider);
    final ticket = await _ticketRepo.createTicket(
      _titleController.text,
      _descriptionController.text,
      currentUser?.username ?? 'unknown',
    );

    if (!mounted) return;

    if (ticket != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket ${ticket.id} created successfully')),
      );
      ref.refresh(userTicketsProvider(currentUser?.username ?? ''));
      Navigator.pop(context);
    } else {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create ticket')),
      );
    }
  }

  void _handleCameraPermission() async {
    final status = await Permission.camera.request();
    
    if (!mounted) return;

    if (status.isGranted) {
      // Navigate to camera screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const CameraScreen(),
        ),
      );
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    } else if (status.isPermanentlyDenied) {
      // Show dialog to open app settings
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Camera Permission'),
          content: const Text(
            'Camera permission is permanently denied. '
            'Please enable it in app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Ticket'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Report a New Issue',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Title field
            const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              enabled: !_isSubmitting,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'e.g., Laptop not working',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            // Description field
            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              enabled: !_isSubmitting,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe the issue in detail...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            // Camera button
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _handleCameraPermission,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Attach Photo (Camera)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            // Submit button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _handleCreateTicket,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Create Ticket'),
            ),
            const SizedBox(height: 12),
            // Cancel button
            OutlinedButton(
              onPressed: _isSubmitting ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
