import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class EnhancedTaskCard extends StatefulWidget {
  final String title;
  final String? description;
  final String priority;
  final bool isCompleted;
  final DateTime? dueDate;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  const EnhancedTaskCard({
    Key? key,
    required this.title,
    this.description,
    required this.priority,
    this.isCompleted = false,
    this.dueDate,
    this.onTap,
    this.onToggle,
  }) : super(key: key);

  @override
  State<EnhancedTaskCard> createState() => _EnhancedTaskCardState();
}

class _EnhancedTaskCardState extends State<EnhancedTaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(widget.priority);
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = ResponsiveUtils.isVerySmallScreen(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isCompleted
                    ? priorityColor.withValues(alpha: 0.3)
                    : colorScheme.outline.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: priorityColor.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.black26
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Priority Indicator
                      Container(
                        width: 6,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              priorityColor,
                              priorityColor.withValues(alpha: 0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: priorityColor.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),

                      // Task Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Priority Badge Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: isSmallScreen ? 15 : 17,
                                          fontWeight: FontWeight.w600,
                                          color: widget.isCompleted
                                              ? colorScheme.onSurface
                                                    .withValues(alpha: 0.5)
                                              : colorScheme.onSurface,
                                          decoration: widget.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          height: 1.3,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Priority Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: priorityColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: priorityColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    widget.priority.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: priorityColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Description
                            if (widget.description?.isNotEmpty ?? false) ...[
                              const SizedBox(height: 8),
                              Text(
                                widget.description!,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.7,
                                      ),
                                      decoration: widget.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      height: 1.4,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],

                            // Due Date and Completion Status Row
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                if (widget.dueDate != null) ...[
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getDueDateColor(
                                          widget.dueDate!,
                                        ).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getDueDateColor(
                                            widget.dueDate!,
                                          ).withValues(alpha: 0.3),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getDueDateIcon(widget.dueDate!),
                                            size: 14,
                                            color: _getDueDateColor(
                                              widget.dueDate!,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              _formatDueDate(widget.dueDate!),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: _getDueDateColor(
                                                  widget.dueDate!,
                                                ),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                // Enhanced Completion Toggle
                                GestureDetector(
                                  onTap: widget.onToggle,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: widget.isCompleted
                                          ? LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                priorityColor,
                                                priorityColor.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ],
                                            )
                                          : null,
                                      color: widget.isCompleted
                                          ? null
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: widget.isCompleted
                                            ? priorityColor
                                            : colorScheme.outline.withValues(
                                                alpha: 0.5,
                                              ),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: widget.isCompleted
                                              ? priorityColor.withValues(
                                                  alpha: 0.4,
                                                )
                                              : Colors.transparent,
                                          blurRadius: widget.isCompleted
                                              ? 8.0
                                              : 0.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: widget.isCompleted
                                        ? Icon(
                                            Icons.check_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
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
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFFF4757);
      case 'medium':
        return const Color(0xFFFFB142);
      case 'low':
        return const Color(0xFF2ED573);
      default:
        return const Color(0xFF8395A7);
    }
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final difference = taskDate.difference(today).inDays;

    if (difference < 0) return const Color(0xFFFF4757); // Overdue - Red
    if (difference == 0) return const Color(0xFFFF6B35); // Due today - Orange
    if (difference <= 3) return const Color(0xFFFFB142); // Due soon - Amber
    return const Color(0xFF2ED573); // Future - Green
  }

  IconData _getDueDateIcon(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final difference = taskDate.difference(today).inDays;

    if (difference < 0) return Icons.warning_rounded; // Overdue
    if (difference == 0) return Icons.today_rounded; // Due today
    if (difference <= 3) return Icons.schedule_rounded; // Due soon
    return Icons.event_rounded; // Future
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final difference = taskDate.difference(today).inDays;

    if (difference < 0) {
      final overdueDays = -difference;
      if (overdueDays == 1) return 'Overdue';
      if (overdueDays < 7) return 'Overdue';
      return 'Overdue';
    }
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference <= 7) return '$difference days';

    final weeks = (difference / 7).floor();
    if (weeks == 1) return '1 week';
    if (weeks < 4) return '$weeks weeks';

    return '${dueDate.day}/${dueDate.month}';
  }
}
