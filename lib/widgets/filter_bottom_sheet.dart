import 'package:flutter/material.dart';
import '../services/filter_presets_service.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _presetNameController = TextEditingController();
  List<Map<String, dynamic>> _savedPresets = [];
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  bool _showCustomDateRange = false;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _loadSavedPresets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _presetNameController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedPresets() async {
    final presets = await FilterPresetsService.getSavedPresets();
    setState(() {
      _savedPresets = presets;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
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
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Filter & Search Tasks',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: _clearFilters,
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
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
              ],
            ),
          ), // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Section
                  _buildSearchSection(),
                  const SizedBox(height: 24),

                  // Saved Presets Section
                  if (_savedPresets.isNotEmpty) ...[
                    _buildPresetsSection(),
                    const SizedBox(height: 24),
                  ],

                  // Status Filter
                  _buildFilterSection('Status', [
                    _FilterOption('all', 'All Tasks', Icons.list_alt),
                    _FilterOption('pending', 'Pending', Icons.pending_actions),
                    _FilterOption('completed', 'Completed', Icons.task_alt),
                  ], 'status'),

                  const SizedBox(height: 24),

                  // Priority Filter
                  _buildFilterSection('Priority', [
                    _FilterOption('all', 'All Priorities', Icons.flag_outlined),
                    _FilterOption(
                      'high',
                      'High Priority',
                      Icons.priority_high,
                      Colors.red,
                    ),
                    _FilterOption(
                      'medium',
                      'Medium Priority',
                      Icons.flag,
                      Colors.orange,
                    ),
                    _FilterOption(
                      'low',
                      'Low Priority',
                      Icons.flag_outlined,
                      Colors.green,
                    ),
                  ], 'priority'),

                  const SizedBox(height: 24),

                  // Due Date Filter
                  _buildFilterSection('Due Date', [
                    _FilterOption('all', 'All Dates', Icons.calendar_month),
                    _FilterOption('today', 'Due Today', Icons.today),
                    _FilterOption('week', 'This Week', Icons.date_range),
                    _FilterOption(
                      'overdue',
                      'Overdue',
                      Icons.warning,
                      Colors.red,
                    ),
                    _FilterOption(
                      'custom',
                      'Custom Range',
                      Icons.date_range_outlined,
                    ),
                  ], 'dueDate'),

                  // Custom Date Range Section
                  if (_showCustomDateRange ||
                      _filters['dueDate'] == 'custom') ...[
                    const SizedBox(height: 16),
                    _buildCustomDateRangeSection(),
                  ],

                  const SizedBox(height: 24),

                  // Category Filter
                  _buildFilterSection('Category', [
                    _FilterOption('all', 'All Categories', Icons.category),
                    _FilterOption('work', 'Work', Icons.work),
                    _FilterOption('personal', 'Personal', Icons.person),
                    _FilterOption('shopping', 'Shopping', Icons.shopping_cart),
                    _FilterOption('health', 'Health', Icons.health_and_safety),
                    _FilterOption('education', 'Education', Icons.school),
                  ], 'category'),

                  const SizedBox(height: 24),

                  // Save Preset Section
                  _buildSavePresetSection(),

                  const SizedBox(height: 16), // Add some bottom padding
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<_FilterOption> options,
    String filterKey,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = _filters[filterKey] == option.value;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _filters[filterKey] = option.value;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      option.icon,
                      size: 18,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : (option.color ??
                                colorScheme.onSurface.withOpacity(0.7)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      option.label,
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _filters = {
        'status': 'all',
        'priority': 'all',
        'category': 'all',
        'dueDate': 'all',
        'search': '',
        'customStartDate': null,
        'customEndDate': null,
      };
      _searchController.clear();
      _customStartDate = null;
      _customEndDate = null;
      _showCustomDateRange = false;
    });
  }

  void _applyFilters() {
    // Include search query and custom date range in filters
    final filtersWithSearch = Map<String, dynamic>.from(_filters);
    filtersWithSearch['search'] = _searchController.text.trim();

    if (_customStartDate != null && _customEndDate != null) {
      filtersWithSearch['customStartDate'] = _customStartDate;
      filtersWithSearch['customEndDate'] = _customEndDate;
    }

    widget.onFiltersChanged(filtersWithSearch);
    Navigator.pop(context);
  }

  Future<void> _savePreset() async {
    final name = _presetNameController.text.trim();
    if (name.isEmpty) {
      _showSnackBar('Please enter a preset name');
      return;
    }

    final filtersToSave = Map<String, dynamic>.from(_filters);
    filtersToSave['search'] = _searchController.text.trim();

    if (_customStartDate != null && _customEndDate != null) {
      filtersToSave['customStartDate'] = _customStartDate?.toIso8601String();
      filtersToSave['customEndDate'] = _customEndDate?.toIso8601String();
    }

    await FilterPresetsService.savePreset(name, filtersToSave);
    _presetNameController.clear();
    await _loadSavedPresets();
    _showSnackBar('Preset "$name" saved successfully!');
  }

  Future<void> _applyPreset(Map<String, dynamic> preset) async {
    final filters = Map<String, dynamic>.from(preset['filters']);

    setState(() {
      _filters = {
        'status': filters['status'] ?? 'all',
        'priority': filters['priority'] ?? 'all',
        'category': filters['category'] ?? 'all',
        'dueDate': filters['dueDate'] ?? 'all',
      };

      _searchController.text = filters['search'] ?? '';

      if (filters['customStartDate'] != null) {
        _customStartDate = DateTime.parse(filters['customStartDate']);
      }
      if (filters['customEndDate'] != null) {
        _customEndDate = DateTime.parse(filters['customEndDate']);
      }

      _showCustomDateRange = _customStartDate != null && _customEndDate != null;
    });

    _showSnackBar('Applied preset "${preset['name']}"');
  }

  Future<void> _deletePreset(String name) async {
    await FilterPresetsService.deletePreset(name);
    await _loadSavedPresets();
    _showSnackBar('Preset "$name" removed');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: (_customStartDate != null && _customEndDate != null)
          ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _showCustomDateRange = true;
        _filters['dueDate'] = 'custom';
      });
    }
  }

  void _clearCustomDateRange() {
    setState(() {
      _customStartDate = null;
      _customEndDate = null;
      _showCustomDateRange = false;
      if (_filters['dueDate'] == 'custom') {
        _filters['dueDate'] = 'all';
      }
    });
  }

  Widget _buildSearchSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Tasks',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by task name or description...',
            prefixIcon: Icon(Icons.search, color: colorScheme.primary),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildPresetsSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Presets',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _savedPresets.map((preset) {
            return GestureDetector(
              onLongPress: () => _showDeletePresetDialog(preset['name']),
              child: ActionChip(
                label: Text(preset['name']),
                avatar: Icon(Icons.bookmark, size: 16),
                onPressed: () => _applyPreset(preset),
                backgroundColor: colorScheme.surfaceContainerHighest,
                side: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCustomDateRangeSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Custom Date Range',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearCustomDateRange,
                tooltip: 'Clear custom range',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectCustomDateRange,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    _customStartDate != null && _customEndDate != null
                        ? '${_formatDate(_customStartDate!)} - ${_formatDate(_customEndDate!)}'
                        : 'Select Date Range',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavePresetSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Save Current Filters',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _presetNameController,
                decoration: InputDecoration(
                  hintText: FilterPresetsService.getSuggestedPresetName(
                    _filters,
                  ),
                  prefixIcon: Icon(
                    Icons.bookmark_add,
                    color: colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: _savePreset,
              icon: const Icon(Icons.save, size: 16),
              label: const Text('Save'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeletePresetDialog(String presetName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Preset'),
        content: Text(
          'Are you sure you want to delete the preset "$presetName"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePreset(presetName);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _FilterOption {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;

  _FilterOption(this.value, this.label, this.icon, [this.color]);
}
