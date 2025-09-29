import 'package:flutter/material.dart';

class TaskListHeader extends StatelessWidget {
  final int taskCount;
  final int completedCount;
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;
  final Function(String) onSortChanged;
  final String currentSort;

  const TaskListHeader({
    super.key,
    required this.taskCount,
    required this.completedCount,
    required this.hasActiveFilters,
    required this.onClearFilters,
    required this.onSortChanged,
    this.currentSort = 'recent',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pendingCount = taskCount - completedCount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.3),
            colorScheme.secondaryContainer.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Main summary row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Showing $taskCount task${taskCount != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getTaskSummaryText(completedCount, pendingCount),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Progress indicator
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.checklist_rounded,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '$completedCount/$taskCount',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Sort button
                    PopupMenuButton<String>(
                      initialValue: currentSort,
                      onSelected: onSortChanged,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.sort_rounded,
                          size: 16,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'recent',
                          child: Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 16),
                              const SizedBox(width: 8),
                              Text('Most Recent'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'priority',
                          child: Row(
                            children: [
                              Icon(Icons.priority_high_rounded, size: 16),
                              const SizedBox(width: 8),
                              Text('Priority'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'dueDate',
                          child: Row(
                            children: [
                              Icon(Icons.event_rounded, size: 16),
                              const SizedBox(width: 8),
                              Text('Due Date'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'alphabetical',
                          child: Row(
                            children: [
                              Icon(Icons.sort_by_alpha_rounded, size: 16),
                              const SizedBox(width: 8),
                              Text('Alphabetical'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Clear filters button (if filters are active)
          if (hasActiveFilters) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    colorScheme.errorContainer.withValues(alpha: 0.8),
                    colorScheme.errorContainer.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClearFilters,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.clear_all_rounded,
                          size: 16,
                          color: colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Clear All Filters',
                          style: TextStyle(
                            color: colorScheme.onErrorContainer,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getTaskSummaryText(int completed, int pending) {
    if (completed == 0) return '$pending pending';
    if (pending == 0) return 'All completed! 🎉';
    return '$completed completed • $pending pending';
  }
}
