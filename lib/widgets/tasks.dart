import 'package:flutter/material.dart';
import 'package:nhom10/models/task_model.dart';
import 'package:nhom10/widgets/empty_state.dart';
import 'package:nhom10/widgets/enhanced_task_card.dart';
import 'package:nhom10/widgets/skeletion_loader.dart';
import 'package:nhom10/widgets/task_list_header.dart';
import 'package:nhom10/services/firebase_service.dart';
import '../l10n/app_localizations.dart';

class TaskWidget extends StatefulWidget {
  final VoidCallback? onTaskChanged;
  final Map<String, dynamic>? filters;
  final String? searchQuery;
  final VoidCallback? onClearSearch;
  final VoidCallback? onClearFilters;
  final bool shrinkWrap;

  const TaskWidget({
    super.key,
    this.onTaskChanged,
    this.filters,
    this.searchQuery,
    this.onClearSearch,
    this.onClearFilters,
    this.shrinkWrap = false,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  List<TaskItemModel> taskList = [];
  List<TaskItemModel> filteredTaskList = [];
  bool isLoading = true;
  String currentSort = 'recent';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void didUpdateWidget(TaskWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters != oldWidget.filters ||
        widget.searchQuery != oldWidget.searchQuery) {
      _applyFilters();
    }
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await FirebaseService.getUserTasks();
      setState(() {
        taskList = tasks;
        isLoading = false;
      });
      _applyFilters();
      // Call the callback to update parent widget
      widget.onTaskChanged?.call();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading tasks: $e');
    }
  }

  int _getCompletedCount() {
    return filteredTaskList.where((task) => task.isCompleted).length;
  }

  bool _hasActiveFilters() {
    if (widget.filters == null) return false;
    return widget.filters!.values.any(
          (value) => value != 'all' && value != '' && value != null,
        ) ||
        (widget.filters!['search'] != null &&
            widget.filters!['search'].toString().isNotEmpty);
  }

  String _getLocalizedPriority(BuildContext context, String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppLocalizations.of(context)!.high;
      case 'medium':
        return AppLocalizations.of(context)!.medium;
      case 'low':
        return AppLocalizations.of(context)!.low;
      default:
        return priority;
    }
  }

  String _getLocalizedCategory(BuildContext context, String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return AppLocalizations.of(context)!.work;
      case 'personal':
        return AppLocalizations.of(context)!.personal;
      case 'shopping':
        return AppLocalizations.of(context)!.shopping;
      case 'health':
        return AppLocalizations.of(context)!.health;
      case 'education':
        return AppLocalizations.of(context)!.education;
      default:
        return category;
    }
  }

  void _sortTasks(String sortType) {
    setState(() {
      currentSort = sortType;
      switch (sortType) {
        case 'priority':
          filteredTaskList.sort((a, b) {
            final priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
            final aPriority = priorityOrder[a.priority.toLowerCase()] ?? 0;
            final bPriority = priorityOrder[b.priority.toLowerCase()] ?? 0;
            return bPriority.compareTo(aPriority);
          });
          break;
        case 'dueDate':
          filteredTaskList.sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) return 0;
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return a.dueDate!.compareTo(b.dueDate!);
          });
          break;
        case 'alphabetical':
          filteredTaskList.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
          );
          break;
        case 'recent':
        default:
          // Sort by creation time or title (most recent first)
          filteredTaskList.sort((a, b) => b.title.compareTo(a.title));
          break;
      }
    });
  }

  void _applyFilters() {
    List<TaskItemModel> filtered = List.from(taskList);

    // Apply search filter first (from searchQuery parameter or filters['search'])
    String searchQuery = widget.searchQuery ?? '';
    if (widget.filters != null && widget.filters!['search'] != null) {
      searchQuery = widget.filters!['search'].toString();
    }

    if (searchQuery.isNotEmpty) {
      final searchLower = searchQuery.toLowerCase();
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(searchLower) ||
            task.description.toLowerCase().contains(searchLower);
      }).toList();
    }

    // Apply other filters if they exist
    if (widget.filters != null && widget.filters!.isNotEmpty) {
      // Filter by completion status
      if (widget.filters!['status'] != null &&
          widget.filters!['status'] != 'all') {
        if (widget.filters!['status'] == 'completed') {
          filtered = filtered.where((task) => task.isCompleted).toList();
        } else if (widget.filters!['status'] == 'pending') {
          filtered = filtered.where((task) => !task.isCompleted).toList();
        }
      }

      // Filter by priority
      if (widget.filters!['priority'] != null &&
          widget.filters!['priority'] != 'all') {
        filtered = filtered
            .where(
              (task) =>
                  task.priority.toLowerCase() ==
                  widget.filters!['priority'].toLowerCase(),
            )
            .toList();
      }

      // Filter by category
      if (widget.filters!['category'] != null &&
          widget.filters!['category'] != 'all') {
        filtered = filtered
            .where(
              (task) =>
                  task.category.toLowerCase() ==
                  widget.filters!['category'].toLowerCase(),
            )
            .toList();
      }

      // Filter by due date
      if (widget.filters!['dueDate'] != null &&
          widget.filters!['dueDate'] != 'all') {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final nextWeek = today.add(const Duration(days: 7));

        switch (widget.filters!['dueDate']) {
          case 'today':
            filtered = filtered.where((task) {
              if (task.dueDate == null) return false;
              final taskDate = DateTime(
                task.dueDate!.year,
                task.dueDate!.month,
                task.dueDate!.day,
              );
              return taskDate == today;
            }).toList();
            break;
          case 'week':
            filtered = filtered.where((task) {
              if (task.dueDate == null) return false;
              final taskDate = DateTime(
                task.dueDate!.year,
                task.dueDate!.month,
                task.dueDate!.day,
              );
              return taskDate.isAfter(
                    today.subtract(const Duration(days: 1)),
                  ) &&
                  taskDate.isBefore(nextWeek);
            }).toList();
            break;
          case 'overdue':
            filtered = filtered.where((task) {
              if (task.dueDate == null) return false;
              final taskDate = DateTime(
                task.dueDate!.year,
                task.dueDate!.month,
                task.dueDate!.day,
              );
              return taskDate.isBefore(today) && !task.isCompleted;
            }).toList();
            break;
          case 'custom':
            // Handle custom date range
            if (widget.filters!['customStartDate'] != null &&
                widget.filters!['customEndDate'] != null) {
              final startDate = widget.filters!['customStartDate'] is DateTime
                  ? widget.filters!['customStartDate'] as DateTime
                  : DateTime.parse(
                      widget.filters!['customStartDate'].toString(),
                    );
              final endDate = widget.filters!['customEndDate'] is DateTime
                  ? widget.filters!['customEndDate'] as DateTime
                  : DateTime.parse(widget.filters!['customEndDate'].toString());

              filtered = filtered.where((task) {
                if (task.dueDate == null) return false;
                final taskDate = DateTime(
                  task.dueDate!.year,
                  task.dueDate!.month,
                  task.dueDate!.day,
                );
                return taskDate.isAfter(
                      startDate.subtract(const Duration(days: 1)),
                    ) &&
                    taskDate.isBefore(endDate.add(const Duration(days: 1)));
              }).toList();
            }
            break;
        }
      }
    }

    setState(() {
      filteredTaskList = filtered;
      _sortTasks(currentSort); // Apply current sort after filtering
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        child: Column(
          children: [
            // Skeleton for task summary header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(
                        height: 14,
                        width: 120,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 4),
                      SkeletonLoader(
                        height: 12,
                        width: 80,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                  SkeletonLoader(
                    height: 28,
                    width: 60,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
            ),

            // Skeleton for task cards
            if (widget.shrinkWrap)
              ...List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader(
                          height: 60,
                          width: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonLoader(
                                height: 17,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              const SizedBox(height: 8),
                              SkeletonLoader(
                                height: 14,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLoader(
                            height: 60,
                            width: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonLoader(
                                  height: 17,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                const SizedBox(height: 8),
                                SkeletonLoader(
                                  height: 14,
                                  width: double.infinity,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Check for empty state
    if (taskList.isEmpty) {
      return EmptyState(
        title: AppLocalizations.of(context)!.noTasksYet,
        subtitle: AppLocalizations.of(context)!.createFirstTask,
        icon: Icons.task_alt,
      );
    }

    // Check for empty filtered results
    if (filteredTaskList.isEmpty && taskList.isNotEmpty) {
      // Check if it's a search query or filters
      bool hasSearchQuery =
          widget.searchQuery != null && widget.searchQuery!.isNotEmpty;
      bool hasFilters =
          widget.filters != null &&
          widget.filters!.values.any((value) => value != 'all');

      if (hasSearchQuery && !hasFilters) {
        // Only search query is active
        return EmptyState(
          title: AppLocalizations.of(context)!.noSearchResults,
          subtitle: AppLocalizations.of(context)!.noTasksMatchSearch,
          icon: Icons.search_off,
          actionText: AppLocalizations.of(context)!.clearSearch,
          onAction: widget.onClearSearch,
        );
      } else if (hasSearchQuery && hasFilters) {
        // Both search and filters are active
        return EmptyState(
          title: AppLocalizations.of(context)!.noMatchingTasks,
          subtitle: AppLocalizations.of(context)!.noTasksMatchCriteria,
          icon: Icons.filter_list_off,
          actionText: AppLocalizations.of(context)!.clearAll,
          onAction: () {
            widget.onClearSearch?.call();
            widget.onClearFilters?.call();
          },
        );
      } else {
        // Only filters are active
        return EmptyState(
          title: AppLocalizations.of(context)!.noMatchingTasks,
          subtitle: AppLocalizations.of(context)!.adjustFilters,
          icon: Icons.filter_list_off,
          actionText: AppLocalizations.of(context)!.clearFilters,
          onAction: widget.onClearFilters,
        );
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        100,
      ), // Extra bottom padding for bottom nav
      child: Column(
        children: [
          // Task Summary Header
          if (filteredTaskList.isNotEmpty) ...[
            TaskListHeader(
              taskCount: filteredTaskList.length,
              completedCount: _getCompletedCount(),
              hasActiveFilters: _hasActiveFilters(),
              onClearFilters: () {
                widget.onClearSearch?.call();
                widget.onClearFilters?.call();
              },
              onSortChanged: _sortTasks,
              currentSort: currentSort,
            ),
          ],

          // Enhanced Task List
          if (widget.shrinkWrap)
            // Non-scrollable version for use inside SingleChildScrollView
            if (filteredTaskList.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.task_alt_outlined,
                        size: 48,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noTasksToDisplay,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.addNewTaskToGetStarted,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: filteredTaskList.map((task) {
                  final index = filteredTaskList.indexOf(task);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutCubic,
                      child: EnhancedTaskCard(
                        title: task.title,
                        description: task.description,
                        priority: task.priority,
                        isCompleted: task.isCompleted,
                        dueDate: task.dueDate,
                        onTap: () => _showTaskDetails(context, task),
                        onToggle: () async {
                          final updatedTask = task.copyWith(
                            isCompleted: !task.isCompleted,
                          );
                          await FirebaseService.updateTask(updatedTask);
                          _loadTasks();
                        },
                      ),
                    ),
                  );
                }).toList(),
              )
          else
            // Scrollable version with Expanded and ListView
            Expanded(
              child: filteredTaskList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.task_alt_outlined,
                              size: 48,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.noTasksToDisplay,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.pullDownToRefresh,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadTasks,
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.surface,
                      strokeWidth: 3,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: filteredTaskList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final task = filteredTaskList[index];
                          return AnimatedContainer(
                            duration: Duration(
                              milliseconds: 300 + (index * 50),
                            ),
                            curve: Curves.easeOutCubic,
                            child: EnhancedTaskCard(
                              title: task.title,
                              description: task.description,
                              priority: task.priority,
                              isCompleted: task.isCompleted,
                              dueDate: task.dueDate,
                              onTap: () => _showTaskDetails(context, task),
                              onToggle: () async {
                                final updatedTask = task.copyWith(
                                  isCompleted: !task.isCompleted,
                                );
                                await FirebaseService.updateTask(updatedTask);
                                _loadTasks();
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  void _showTaskDetails(BuildContext context, TaskItemModel task) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 28,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: task.priorityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getLocalizedPriority(context, task.priority).toUpperCase(),
                    style: TextStyle(
                      color: task.priorityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getLocalizedCategory(context, task.category),
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (task.dueDate != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${AppLocalizations.of(context)!.dueLabel} ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedTask = task.copyWith(
                        isCompleted: !task.isCompleted,
                      );
                      await FirebaseService.updateTask(updatedTask);
                      Navigator.pop(context);
                      _loadTasks(); // Refresh tasks
                      widget.onTaskChanged?.call(); // Notify parent
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.isCompleted
                          ? colorScheme.secondary
                          : colorScheme.primary,
                    ),
                    child: Text(
                      task.isCompleted
                          ? AppLocalizations.of(context)!.markAsPending
                          : AppLocalizations.of(context)!.markAsCompleted,
                      style: TextStyle(
                        color: task.isCompleted
                            ? colorScheme.onSecondary
                            : colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseService.deleteTask(task.id!);
                    Navigator.pop(context);
                    _loadTasks(); // Refresh tasks
                    widget.onTaskChanged?.call(); // Notify parent
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
