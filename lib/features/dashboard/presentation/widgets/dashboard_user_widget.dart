import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../ticket/presentation/providers/ticket_provider.dart';
import '../../../../core/theme/theme_provider.dart';

class DashboardUserWidget extends ConsumerWidget {
  const DashboardUserWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userTicketsAsync = ref.watch(
      userTicketsProvider(currentUser?.username ?? ''),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section - Clean text only
          Text(
            'Welcome back,',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentUser?.username ?? 'User',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Here\'s your ticket overview',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),

          // Stats section
          userTicketsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
            data: (tickets) {
              final totalTickets = tickets.length;
              final activeTickets =
                  tickets.where((t) => t.status != 'done' && t.status != 'cancelled').length;
              final completedTickets = tickets.where((t) => t.status == 'done').length;

              return Column(
                children: [
                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Tickets',
                          value: totalTickets.toString(),
                          icon: Icons.confirmation_number_outlined,
                          isAccent: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Active',
                          value: activeTickets.toString(),
                          icon: Icons.access_time_outlined,
                          isAccent: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Completed',
                          value: completedTickets.toString(),
                          icon: Icons.check_circle_outline,
                          isAccent: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Theme',
                          value: ref.watch(themeModeProvider) ? 'Dark' : 'Light',
                          icon: ref.watch(themeModeProvider)
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          isAccent: false,
                          onTap: () {
                            ref.read(themeModeProvider.notifier).state =
                                !ref.read(themeModeProvider);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isAccent;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.isAccent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isAccent ? const Color(0xFF000072) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isAccent
                    ? Colors.white
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
                size: 24,
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: isAccent ? Colors.white : null,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isAccent
                      ? Colors.white70
                      : (isDark ? Colors.grey[500] : Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
