import 'package:flutter/material.dart';
import 'package:nhom10/widgets/tasks.dart';
import 'package:nhom10/widgets/filter_bottom_sheet.dart';
import 'profile.dart';
import 'menu.dart';
import 'add_task.dart';
import '../services/firebase_service.dart';
import '../services/filter_presets_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, int> taskStats = {'pending': 0, 'completed': 0, 'total': 0};
  Map<String, dynamic> currentFilters = {
    'status': 'all',
    'priority': 'all',
    'category': 'all',
    'dueDate': 'all',
    'search': '',
    'customStartDate': null,
    'customEndDate': null,
  };
  int _refreshTrigger = 0;

  @override
  void initState() {
    super.initState();
    _loadTaskStats();
  }

  Future<void> _loadTaskStats() async {
    final stats = await FirebaseService.getTaskStats();
    setState(() {
      taskStats = stats;
    });
  }

  void _updateFilters(Map<String, dynamic> newFilters) async {
    // Initialize FilterPresetsService if not already done
    await FilterPresetsService.init();

    setState(() {
      currentFilters = newFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context),
      body: HomePage(
        key: ValueKey(_refreshTrigger),
        taskStats: taskStats,
        onTaskStatsChanged: _loadTaskStats,
        filters: currentFilters,
        onFiltersChanged: _updateFilters,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          // If a task was added, refresh the task stats and trigger rebuild
          if (result == true) {
            await _loadTaskStats();
            // Force a rebuild to refresh the entire HomePage and TaskWidget
            setState(() {
              _refreshTrigger++;
            });
          }
        },
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.1),
            colorScheme.surface,
          ],
        ),
      ),
    ),
    title: Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Hero(
            tag: 'profile_avatar',
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: colorScheme.surface,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: const AssetImage('assets/profile.png'),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello! 👋',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontSize: 20,
                ),
              ),
              Text(
                'Let\'s be productive today',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      Container(
        margin: const EdgeInsets.only(right: 8),
        child: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.menu_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MenuPage()),
            );
          },
        ),
      ),
    ],
  );
}

class HomePage extends StatefulWidget {
  final Map<String, int> taskStats;
  final VoidCallback onTaskStatsChanged;
  final Map<String, dynamic> filters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const HomePage({
    super.key,
    required this.taskStats,
    required this.onTaskStatsChanged,
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize search controller with current filter value
    final currentSearch = widget.filters['search'] ?? '';
    _searchController.text = currentSearch;
    _searchQuery = currentSearch;
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update search controller if filters changed externally
    final currentSearch = widget.filters['search'] ?? '';
    if (_searchController.text != currentSearch) {
      _searchController.text = currentSearch;
      setState(() {
        _searchQuery = currentSearch;
      });
    }
  }

  bool get _hasActiveFilters {
    return widget.filters.values.any(
          (value) => value != 'all' && value != '' && value != null,
        ) ||
        (widget.filters['search'] != null &&
            widget.filters['search'].toString().isNotEmpty);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    // Update filters with search query
    final updatedFilters = Map<String, dynamic>.from(widget.filters);
    updatedFilters['search'] = query;
    widget.onFiltersChanged(updatedFilters);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });

    // Clear search in filters
    final updatedFilters = Map<String, dynamic>.from(widget.filters);
    updatedFilters['search'] = '';
    widget.onFiltersChanged(updatedFilters);
  }

  void _clearFilters() {
    final clearedFilters = {
      'status': 'all',
      'priority': 'all',
      'category': 'all',
      'dueDate': 'all',
      'search': '',
      'customStartDate': null,
      'customEndDate': null,
    };
    widget.onFiltersChanged(clearedFilters);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact Welcome Section with Stats Cards
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compact Main Stats Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.task_alt_rounded,
                          size: 20,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Progress',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onPrimary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildStatsChip(
                                  '${widget.taskStats['completed'] ?? 0}',
                                  'Done',
                                  Icons.check_circle_rounded,
                                  colorScheme.onPrimary,
                                ),
                                const SizedBox(width: 8),
                                _buildStatsChip(
                                  '${widget.taskStats['pending'] ?? 0}',
                                  'Left',
                                  Icons.access_time_rounded,
                                  colorScheme.onPrimary.withValues(alpha: 0.8),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Compact completion rate display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.taskStats['total'] != null && widget.taskStats['total']! > 0 ? ((widget.taskStats['completed']! / widget.taskStats['total']!) * 100).round() : 0}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Compact Search and Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Compact Search Bar
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _searchQuery.isNotEmpty
                                ? colorScheme.primary.withValues(alpha: 0.3)
                                : colorScheme.outline.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          autofocus: false,
                          enableInteractiveSelection: true,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search tasks...',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: _searchQuery.isNotEmpty
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                              size: 16,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    onPressed: _clearSearch,
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: 16,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Compact Filter Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: _hasActiveFilters
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.primary.withValues(alpha: 0.8),
                                ],
                              )
                            : null,
                        color: _hasActiveFilters
                            ? null
                            : colorScheme.surfaceContainerHighest.withValues(
                                alpha: 0.5,
                              ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _hasActiveFilters
                              ? colorScheme.primary.withValues(alpha: 0.3)
                              : colorScheme.outline.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => FilterBottomSheet(
                              currentFilters: widget.filters,
                              onFiltersChanged: widget.onFiltersChanged,
                            ),
                          );
                        },
                        icon: Stack(
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color: _hasActiveFilters
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                              size: 18,
                            ),
                            if (_hasActiveFilters)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: colorScheme.onPrimary,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Compact Tasks List Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.15),
                            colorScheme.secondary.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.task_alt_rounded,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Your Tasks',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                if (_hasActiveFilters)
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _clearFilters,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.clear_all_rounded,
                                size: 14,
                                color: colorScheme.onErrorContainer,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Clear',
                                style: TextStyle(
                                  color: colorScheme.onErrorContainer,
                                  fontSize: 11,
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
            ),
          ),

          const SizedBox(height: 8),

          // Tasks List - Direct integration without frame
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TaskWidget(
              onTaskChanged: widget.onTaskStatsChanged,
              filters: widget.filters,
              onClearSearch: _clearSearch,
              onClearFilters: _clearFilters,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsChip(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8)),
        ),
      ],
    );
  }
}
