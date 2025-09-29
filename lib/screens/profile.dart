import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? userProfile;
  Map<String, int> taskStats = {'completed': 0, 'pending': 0, 'total': 0};
  Map<String, int> tasksByCategory = {};
  Map<String, int> tasksByPriority = {};
  Map<String, int> weeklyProgress = {};
  List<TaskItemModel> recentTasks = [];
  bool isLoading = true;
  double completionRate = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (FirebaseService.currentUserId != null) {
      final results = await Future.wait([
        FirebaseService.getUserProfile(FirebaseService.currentUserId!),
        FirebaseService.getTaskStats(),
        FirebaseService.getRecentTasks(10),
        FirebaseService.getUserTasks(), // Get all tasks for detailed analysis
      ]);

      final allTasks = results[3] as List<TaskItemModel>;

      setState(() {
        userProfile = results[0] as UserModel?;
        taskStats = results[1] as Map<String, int>;
        recentTasks = results[2] as List<TaskItemModel>;

        // Calculate detailed statistics
        _calculateDetailedStats(allTasks);

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _calculateDetailedStats(List<TaskItemModel> tasks) {
    // Calculate completion rate
    if (taskStats['total']! > 0) {
      completionRate = taskStats['completed']! / taskStats['total']!;
    }

    // Calculate tasks by category
    tasksByCategory.clear();
    for (var task in tasks) {
      tasksByCategory[task.category] =
          (tasksByCategory[task.category] ?? 0) + 1;
    }

    // Calculate tasks by priority
    tasksByPriority.clear();
    for (var task in tasks) {
      String priority = task.priority.toLowerCase();
      priority =
          priority[0].toUpperCase() +
          priority.substring(1); // Capitalize first letter
      tasksByPriority[priority] = (tasksByPriority[priority] ?? 0) + 1;
    }

    // Calculate weekly progress (last 7 days) - use createdAt for completed tasks
    weeklyProgress.clear();
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayKey = '${date.day}/${date.month}';
      weeklyProgress[dayKey] = 0;

      for (var task in tasks) {
        if (task.isCompleted && _isSameDay(task.createdAt, date)) {
          weeklyProgress[dayKey] = weeklyProgress[dayKey]! + 1;
        }
      }
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(),
              const SizedBox(height: 24),

              // Enhanced User Information
              _buildUserInfo(),
              const SizedBox(height: 24),

              // Quick Stats
              _buildQuickStats(),
              const SizedBox(height: 24),

              // Productivity Insights
              _buildProductivityInsights(),
              const SizedBox(height: 24),

              // Task Distribution
              _buildTaskDistribution(),
              const SizedBox(height: 24),

              // Weekly Progress
              _buildWeeklyProgress(),
              const SizedBox(height: 24),

              // Recent Activity
              _buildRecentActivity(),
              const SizedBox(height: 24),

              // Achievements (simplified)
              _buildAchievements(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Simple profile image
          CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.primary,
            backgroundImage:
                userProfile?.photoUrl != null &&
                    userProfile!.photoUrl!.isNotEmpty
                ? NetworkImage(userProfile!.photoUrl!)
                : null,
            child:
                userProfile?.photoUrl == null || userProfile!.photoUrl!.isEmpty
                ? Icon(Icons.person, size: 50, color: colorScheme.onPrimary)
                : null,
          ),
          const SizedBox(height: 16),

          // Name and greeting
          Text(
            'Hello, ${userProfile?.displayName != null ? userProfile!.displayName.split(' ').first : 'Friend'}! 👋',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Email (if available)
          if (userProfile?.email != null)
            Text(
              userProfile!.email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '${taskStats['completed']}',
                'Completed',
                Colors.green.shade600,
                icon: Icons.check_circle,
              ),
              Container(
                height: 40,
                width: 1,
                color: colorScheme.outline.withValues(alpha: 0.4),
              ),
              _buildStatItem(
                '${taskStats['pending']}',
                'Pending',
                Colors.orange.shade600,
                icon: Icons.schedule,
              ),
              Container(
                height: 40,
                width: 1,
                color: colorScheme.outline.withValues(alpha: 0.4),
              ),
              _buildStatItem(
                '${taskStats['total']}',
                'Total Tasks',
                colorScheme.primary,
                icon: Icons.list_alt,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Additional quick stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSmallStatItem(
                '${(completionRate * 100).toInt()}%',
                'Success Rate',
                completionRate > 0.7
                    ? Colors.green.shade600
                    : Colors.orange.shade600,
              ),
              _buildSmallStatItem(
                '${tasksByCategory.length}',
                'Categories',
                Colors.purple.shade600,
              ),
              _buildSmallStatItem(
                '${_calculateDailyAverage().toStringAsFixed(1)}',
                'Daily Avg',
                Colors.blue.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (recentTasks.isNotEmpty)
                TextButton(
                  onPressed: _showAllActivity,
                  child: const Text('View All'),
                ),
            ],
          ),
          const SizedBox(height: 16),

          if (recentTasks.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 48,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No recent activity',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            )
          else
            ...recentTasks
                .take(3)
                .map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildActivityItem(task),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate achievements
    final achievements = _calculateAchievements();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Achievements 🏆',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Achievement badges in rows
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: achievements
                .map(
                  (achievement) => _buildAchievementBadge(
                    achievement['icon'] as IconData,
                    achievement['title'] as String,
                    achievement['earned'] as bool,
                    description: achievement['description'] as String,
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 16),

          // Achievement progress
          Text(
            'Progress: ${achievements.where((a) => a['earned']).length}/${achievements.length} achievements unlocked',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(TaskItemModel task) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (task.isCompleted ? Colors.green : Colors.blue).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            task.isCompleted ? Icons.check_circle_outline : Icons.add_task,
            color: task.isCompleted ? Colors.green : Colors.blue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.isCompleted
                    ? 'Completed "${task.title}"'
                    : 'Created "${task.title}"',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _formatTimeAgo(task.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        // Category chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getCategoryColor(task.category).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            task.category,
            style: TextStyle(
              fontSize: 10,
              color: _getCategoryColor(task.category),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadge(
    IconData icon,
    String title,
    bool earned, {
    String? description,
  }) {
    return GestureDetector(
      onTap: description != null
          ? () => _showAchievementDetails(title, description, earned)
          : null,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: earned
                  ? Colors.amber.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: earned ? Colors.amber : Colors.grey.shade400,
                width: 2,
              ),
              boxShadow: earned
                  ? [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: earned ? Colors.amber.shade700 : Colors.grey.shade400,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: earned ? Colors.amber.shade700 : Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _calculateAchievements() {
    final completed = taskStats['completed'] ?? 0;
    final total = taskStats['total'] ?? 0;
    final categories = tasksByCategory.length;

    return [
      {
        'icon': Icons.task_alt,
        'title': 'First Task',
        'description': 'Create your first task',
        'earned': total > 0,
      },
      {
        'icon': Icons.check_circle,
        'title': 'Finisher',
        'description': 'Complete your first task',
        'earned': completed > 0,
      },
      {
        'icon': Icons.trending_up,
        'title': 'Productive',
        'description': 'Complete 5 tasks',
        'earned': completed >= 5,
      },
      {
        'icon': Icons.star,
        'title': 'Task Master',
        'description': 'Complete 20 tasks',
        'earned': completed >= 20,
      },
      {
        'icon': Icons.flash_on,
        'title': 'Lightning',
        'description': 'Complete 50 tasks',
        'earned': completed >= 50,
      },
      {
        'icon': Icons.category,
        'title': 'Organizer',
        'description': 'Use 3 different categories',
        'earned': categories >= 3,
      },
      {
        'icon': Icons.percent,
        'title': 'Achiever',
        'description': 'Maintain 80% completion rate',
        'earned': completionRate >= 0.8 && total >= 5,
      },
      {
        'icon': Icons.local_fire_department,
        'title': 'Streak',
        'description': 'Complete tasks for 7 days',
        'earned': _hasWeeklyStreak(),
      },
    ];
  }

  bool _hasWeeklyStreak() {
    // Simple check - if user has completed tasks in at least 5 of the last 7 days
    final activeDays = weeklyProgress.values.where((count) => count > 0).length;
    return activeDays >= 5;
  }

  void _showAchievementDetails(String title, String description, bool earned) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              earned ? Icons.emoji_events : Icons.lock,
              color: earned ? Colors.amber : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    Color color, {
    IconData? icon,
  }) {
    return Column(
      children: [
        if (icon != null) Icon(icon, color: color, size: 24),
        if (icon != null) const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSmallStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'personal':
        return Colors.orange;
      case 'shopping':
        return Colors.purple;
      case 'health':
        return Colors.red;
      case 'study':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildUserInfo() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Account Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildInfoRow(
            'Email',
            userProfile?.email ?? 'Not available',
            Icons.email_outlined,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Member Since',
            _formatMemberSince(),
            Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Last Updated',
            _formatLastUpdate(),
            Icons.update_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }

  Widget _buildProductivityInsights() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Productivity Insights',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Completion Rate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Completion Rate',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(completionRate * 100).toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: completionRate > 0.7
                      ? Colors.green
                      : completionRate > 0.4
                      ? Colors.orange
                      : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: completionRate,
            backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              completionRate > 0.7
                  ? Colors.green
                  : completionRate > 0.4
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
          const SizedBox(height: 16),

          // Average tasks per day
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Average',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_calculateDailyAverage().toStringAsFixed(1)} tasks',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDistribution() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart_outline, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Task Distribution',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // By Category
          Text(
            'By Category',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...tasksByCategory.entries
              .map(
                (entry) => _buildDistributionItem(
                  entry.key,
                  entry.value,
                  _getCategoryColor(entry.key),
                ),
              )
              .toList(),

          const SizedBox(height: 16),

          // By Priority
          Text(
            'By Priority',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...tasksByPriority.entries
              .map(
                (entry) => _buildDistributionItem(
                  entry.key,
                  entry.value,
                  _getPriorityColor(entry.key),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDistributionItem(String label, int count, Color color) {
    final theme = Theme.of(context);
    final total = taskStats['total'] ?? 0;
    final percentage = total > 0 ? (count / total) * 100 : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text(
            '$count (${percentage.toStringAsFixed(1)}%)',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Weekly Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bars for each day
          ...weeklyProgress.entries.map((entry) {
            final maxTasks = weeklyProgress.values.isEmpty
                ? 1
                : weeklyProgress.values
                      .reduce((a, b) => a > b ? a : b)
                      .toDouble();
            final progress = maxTasks > 0 ? entry.value / maxTasks : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(entry.key, style: theme.textTheme.bodySmall),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: colorScheme.outline.withValues(
                        alpha: 0.2,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${entry.value}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  double _calculateDailyAverage() {
    if (userProfile?.createdAt == null) return 0.0;

    final now = DateTime.now();
    final memberSince = userProfile!.createdAt;
    final daysSinceMember = now.difference(memberSince).inDays;

    if (daysSinceMember == 0) return taskStats['total']?.toDouble() ?? 0.0;

    return (taskStats['total'] ?? 0) / daysSinceMember;
  }

  String _formatMemberSince() {
    if (userProfile?.createdAt == null) return 'Unknown';

    final memberSince = userProfile!.createdAt;
    final now = DateTime.now();
    final difference = now.difference(memberSince);

    if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  String _formatLastUpdate() {
    if (userProfile?.updatedAt == null) return 'Unknown';
    return _formatTimeAgo(userProfile!.updatedAt);
  }

  void _showAllActivity() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Activity'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: recentTasks.isEmpty
              ? const Center(child: Text('No activity to show'))
              : ListView.builder(
                  itemCount: recentTasks.length,
                  itemBuilder: (context, index) {
                    final task = recentTasks[index];
                    return ListTile(
                      leading: Icon(
                        task.isCompleted ? Icons.check_circle : Icons.add_task,
                        color: task.isCompleted ? Colors.green : Colors.blue,
                        size: 20,
                      ),
                      title: Text(
                        task.isCompleted
                            ? 'Completed "${task.title}"'
                            : 'Created "${task.title}"',
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        _formatTimeAgo(task.createdAt),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(
                            task.category,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          task.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: _getCategoryColor(task.category),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
